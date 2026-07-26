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

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<void>>((ref) {
  return AuthNotifier(ref);
});

class AuthNotifier extends StateNotifier<AsyncValue<void>> {
  AuthNotifier(this.ref) : super(const AsyncValue.data(null));

  final Ref ref;

  AuthRepository get _repository => ref.read(authRepositoryProvider);

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final result = await _repository.loginWithEmail(
        email: email,
        password: password,
      );
      result.fold(
        (failure) => throw failure,
        (user) => null,
      );
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> register(String email, String password, String displayName) async {
    state = const