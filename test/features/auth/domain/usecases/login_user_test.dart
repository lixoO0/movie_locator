import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:movie_locator/features/auth/domain/usecases/login_user.dart';
import 'package:movie_locator/features/auth/domain/repositories/auth_repository.dart';
import 'package:movie_locator/features/auth/domain/entities/user.dart';
import 'package:movie_locator/core/errors/failures.dart';

import 'login_user_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late LoginUser useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginUser(mockRepository);
  });

  const testEmail = 'test@example.com';
  const testPassword = 'password123';
  const testUser = User(
    id: '1',
    email: testEmail,
    displayName: 'Test User',
  );

  test('should login user from repository', () async {
    // Arrange
    when(mockRepository.login(testEmail, testPassword))
        .thenAnswer((_) async => const Right(testUser));

    // Act
    final result = await useCase(const LoginUserParams(
      email: testEmail,
      password: testPassword,
    ));

    // Assert
    expect(result, const Right(testUser));
    verify(mockRepository.login(testEmail, testPassword));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return failure when login fails', () async {
    // Arrange
    const failure = AuthenticationFailure(message: 'Invalid credentials');
    when(mockRepository.login(testEmail, testPassword))
        .thenAnswer((_) async => const Left(failure));

    // Act
    final result = await useCase(const LoginUserParams(
      email: testEmail,
      password: testPassword,
    ));

    // Assert
    expect(result, const Left(failure));
    verify(mockRepository.login(testEmail, testPassword));
    verifyNoMoreInteractions(mockRepository);
  });
}

