import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:movie_locator/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:movie_locator/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:movie_locator/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:movie_locator/features/auth/domain/entities/user.dart';
import 'package:movie_locator/core/errors/exceptions.dart';
import 'package:movie_locator/core/errors/failures.dart';

import 'auth_repository_impl_test.mocks.dart';

@GenerateMocks([AuthRemoteDataSource, AuthLocalDataSource])
void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockAuthLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockLocalDataSource = MockAuthLocalDataSource();
    repository = AuthRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  const testEmail = 'test@example.com';
  const testPassword = 'password123';
  const testDisplayName = 'Test User';
  const testUser = User(
    id: '1',
    email: testEmail,
    displayName: testDisplayName,
  );

  group('login', () {
    test('should return user when login is successful', () async {
      // Arrange
      when(mockRemoteDataSource.login(testEmail, testPassword))
          .thenAnswer((_) async => testUser);
      when(mockLocalDataSource.cacheUser(any))
          .thenAnswer((_) async => {});
      when(mockLocalDataSource.cacheAuthToken(any))
          .thenAnswer((_) async => {});

      // Act
      final result = await repository.login(testEmail, testPassword);

      // Assert
      expect(result, const Right(testUser));
      verify(mockRemoteDataSource.login(testEmail, testPassword));
      verify(mockLocalDataSource.cacheUser(testUser));
      verify(mockLocalDataSource.cacheAuthToken(any));
    });

    test('should return AuthenticationFailure when login fails with invalid credentials', () async {
      // Arrange
      when(mockRemoteDataSource.login(testEmail, testPassword))
          .thenThrow(const AuthenticationException(message: 'Invalid credentials'));

      // Act
      final result = await repository.login(testEmail, testPassword);

      // Assert
      expect(result, isA<Left<Failure, User>>());
      verify(mockRemoteDataSource.login(testEmail, testPassword));
      verifyNever(mockLocalDataSource.cacheUser(any));
    });
  });

  group('register', () {
    test('should return user when registration is successful', () async {
      // Arrange
      when(mockRemoteDataSource.register(testEmail, testPassword, testDisplayName))
          .thenAnswer((_) async => testUser);
      when(mockLocalDataSource.cacheUser(any))
          .thenAnswer((_) async => {});
      when(mockLocalDataSource.cacheAuthToken(any))
          .thenAnswer((_) async => {});

      // Act
      final result = await repository.register(testEmail, testPassword, testDisplayName);

      // Assert
      expect(result, const Right(testUser));
      verify(mockRemoteDataSource.register(testEmail, testPassword, testDisplayName));
      verify(mockLocalDataSource.cacheUser(testUser));
      verify(mockLocalDataSource.cacheAuthToken(any));
    });
  });

  group('logout', () {
    test('should clear user data on logout', () async {
      // Arrange
      when(mockRemoteDataSource.logout())
          .thenAnswer((_) async => {});
      when(mockLocalDataSource.clearUser())
          .thenAnswer((_) async => {});
      when(mockLocalDataSource.clearAuthToken())
          .thenAnswer((_) async => {});

      // Act
      final result = await repository.logout();

      // Assert
      expect(result, const Right(null));
      verify(mockRemoteDataSource.logout());
      verify(mockLocalDataSource.clearUser());
      verify(mockLocalDataSource.clearAuthToken());
    });
  });

  group('getCurrentUser', () {
    test('should return cached user when available', () async {
      // Arrange
      when(mockLocalDataSource.getCachedUser())
          .thenAnswer((_) async => testUser);

      // Act
      final result = await repository.getCurrentUser();

      // Assert
      expect(result, const Right(testUser));
      verify(mockLocalDataSource.getCachedUser());
    });

    test('should return null when no cached user', () async {
      // Arrange
      when(mockLocalDataSource.getCachedUser())
          .thenAnswer((_) async => null);

      // Act
      final result = await repository.getCurrentUser();

      // Assert
      expect(result, const Right(null));
      verify(mockLocalDataSource.getCachedUser());
    });
  });
}

