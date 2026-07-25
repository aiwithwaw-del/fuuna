import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:fuuna/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:fuuna/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:fuuna/features/auth/domain/entities/user_entity.dart';
import 'package:fuuna/core/errors/failures.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockAuthRemoteDataSource();
    repository = AuthRepositoryImpl(remoteDataSource: mockDataSource);
  });

  group('loginWithEmail', () {
    const tEmail = 'test@example.com';
    const tPassword = 'password123';
    const tUser = UserEntity(
      uid: '123',
      email: tEmail,
      displayName: 'Test User',
    );

    test('should return UserEntity when login is successful', () async {
      // arrange
      when(mockDataSource.loginWithEmail(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => tUser);

      // act
      final result = await repository.loginWithEmail(
        email: tEmail,
        password: tPassword,
      );

      // assert
      expect(result, const Right(tUser));
      verify(mockDataSource.loginWithEmail(email: tEmail, password: tPassword));
    });
  });
}