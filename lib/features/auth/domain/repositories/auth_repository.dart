import 'package:dartz/dartz.dart';
import 'package:fuuna/core/errors/failures.dart';
import 'package:fuuna/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Stream<UserEntity?> get authStateChanges;

  Future<Either<Failure, UserEntity>> loginWithEmail({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
  });

  Future<Either<Failure, UserEntity>> signInWithGoogle();

  Future<Either<Failure, UserEntity>> signInWithApple();

  Future<Either<Failure, void>> sendEmailVerification();

  Future<Either<Failure, void>> sendPasswordResetEmail(String email);

  Future<Either<Failure, void>> verifyPhoneNumber(String phoneNumber);

  Future<Either<Failure, void>> updateProfile({
    String? displayName,
    String? photoUrl,
  });

  Future<void> signOut();
}