import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuuna/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:fuuna/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:fuuna/features/auth/domain/entities/user_entity.dart';
import 'package:fuuna/features/auth/domain/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: AuthRemoteDataSource(),
  );
});

final authStateProvider = StreamProvider<UserEntity?>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.authStateChanges;
});

final currentUserProvider = Provider<UserEntity?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.valueOrNull;
});

class AuthNotifier extends StateNotifier<AsyncValue<void>> {
  AuthNotifier(this._ref) : super(const AsyncValue.data(null));
  
  final Ref _ref;
  
  AuthRepository get _repository => _ref.read(authRepositoryProvider);
  
  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final result = await _repository.loginWithEmail(
        email: email,
        password: password,
      );
      result.fold(
        (failure) => state = AsyncValue.error(failure, StackTrace.current),
        (user) => state = const AsyncValue.data(null),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
  
  Future<void> register(String email, String password, String displayName) async {
    state = const AsyncValue.loading();
    try {
      final result = await _repository.registerWithEmail(
        email: email,
        password: password,
        displayName: displayName,
      );
      result.fold(
        (failure) => state = AsyncValue.error(failure, StackTrace.current),
        (user) => state = const AsyncValue.data(null),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
  
  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();
    try {
      final result = await _repository.signInWithGoogle();
      result.fold(
        (failure) => state = AsyncValue.error(failure, StackTrace.current),
        (user) => state = const AsyncValue.data(null),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
  
  Future<void> forgotPassword(String email) async {
    state = const AsyncValue.loading();
    try {
      final result = await _repository.sendPasswordResetEmail(email);
      result.fold(
        (failure) => state = AsyncValue.error(failure, StackTrace.current),
        (_) => state = const AsyncValue.data(null),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
  
  Future<void> signOut() async {
    await _repository.signOut();
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AsyncValue<void>>((ref) {
  return AuthNotifier(ref);
});