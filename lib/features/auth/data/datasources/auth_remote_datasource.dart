import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;
  
  AuthRemoteDataSource({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    GoogleSignIn? googleSignIn,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();
  
  Stream<UserModel?> get authStateChanges {
    return _auth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;
      return _getUserData(firebaseUser.uid);
    });
  }
  
  Future<UserModel> loginWithEmail({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _getUserData(credential.user!.uid);
  }
  
  Future<UserModel> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    
    await credential.user!.updateDisplayName(displayName);
    
    final userModel = UserModel(
      uid: credential.user!.uid,
      email: email,
      displayName: displayName,
      role: UserRole.user,
      isEmailVerified: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    await _firestore.collection('users').doc(userModel.uid).set(userModel.toJson());
    return userModel;
  }
  
  Future<UserModel> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) throw Exception('Google sign in aborted');
    
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    
    final userCredential = await _auth.signInWithCredential(credential);
    final firebaseUser = userCredential.user!;
    
    // Check if user exists in Firestore
    final userDoc = await _firestore.collection('users').doc(firebaseUser.uid).get();
    
    if (!userDoc.exists) {
      final userModel = UserModel(
        uid: firebaseUser.uid,
        email: firebaseUser.email!,
        displayName: firebaseUser.displayName,
        photoUrl: firebaseUser.photoURL,
        role: UserRole.user,
        isEmailVerified: firebaseUser.emailVerified,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await _firestore.collection('users').doc(userModel.uid).set(userModel.toJson());
      return userModel;
    }
    
    return UserModel.fromJson(userDoc.data()!);
  }
  
  Future<UserModel> signInWithApple() async {
    // TODO: Implement Apple Sign In
    throw UnimplementedError();
  }
  
  Future<void> sendEmailVerification() async {
    final user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }
  
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
  
  Future<void> updateProfile({
    String? displayName,
    String? photoUrl,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user logged in');
    
    if (displayName != null) await user.updateDisplayName(displayName);
    if (photoUrl != null) await user.updatePhotoURL(photoUrl);
    
    await _firestore.collection('users').doc(user.uid).update({
      if (displayName != null) 'displayName': displayName,
      if (photoUrl != null) 'photoUrl': photoUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
  
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
  
  Future<UserModel> _getUserData(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) {
      final firebaseUser = _auth.currentUser!;
      return UserModel(
        uid: firebaseUser.uid,
        email: firebaseUser.email!,
        displayName: firebaseUser.displayName,
        photoUrl: firebaseUser.photoURL,
        isEmailVerified: firebaseUser.emailVerified,
      );
    }
    return UserModel.fromJson(doc.data()!);
  }
}