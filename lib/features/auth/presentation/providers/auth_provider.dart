import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fuuna/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:fuuna/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:fuuna/features/auth/domain/entities/user_entity.dart';
import 'package:fuuna/features/auth/domain/repositories/auth_repository.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(
    remoteDataSource: AuthRemoteDataSource(),
  );
}

@Riverpod(keepAlive: true)
Stream<UserEntity?> authState(Ref ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.authStateChanges;
}

@Riverpod(keepAlive: true)
UserEntity? currentUser(Ref ref) {
  final authState = ref.watch(authStateProvider);
  return authState.valueOrNull;
}

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);
  
  AuthRepository get _repository => ref.read(authRepositoryProvider);
  
  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final result = await _repository.loginWithEmail(
        email: email,
        password: password,
      );
      result.fold(
        (failure) => throw failure,
        (user) => null,
      );
    });
  }
  
  Future<void> register(String email, String password, String displayName) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final result = await _repository.registerWithEmail(
        email: email,
        password: password,
        displayName: displayName,
      );
      result.fold(
        (failure) => throw failure,
        (user) => null,
      );
    });
  }
  
  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final result = await _repository.signInWithGoogle();
      result.fold(
        (failure) => throw failure,
        (user) => null,
      );
    });
  }
  
  Future<void> forgotPassword(String email) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final result = await _repository.sendPasswordResetEmail(email);
      result.fold(
        (failure) => throw failure,
        (_) => null,
      );
    });
  }
  
  Future<void> signOut() async {
    await _repository.signOut();
  }
}