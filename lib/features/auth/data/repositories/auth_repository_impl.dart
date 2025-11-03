import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/auth_local_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  
  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });
  
  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final user = await remoteDataSource.login(email, password);
      // Cache user and token with error handling
      try {
        await localDataSource.cacheUser(user);
        await localDataSource.cacheAuthToken('mock_token_${user.id}');
      } catch (cacheError) {
        // Log but don't fail login if cache fails
        print('Warning: Failed to cache user: $cacheError');
      }
      return Right(user);
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, User>> register(String email, String password, String displayName) async {
    try {
      final user = await remoteDataSource.register(email, password, displayName);
      // Cache user and token with error handling
      try {
        await localDataSource.cacheUser(user);
        await localDataSource.cacheAuthToken('mock_token_${user.id}');
      } catch (cacheError) {
        // Log but don't fail registration if cache fails
        print('Warning: Failed to cache user: $cacheError');
      }
      return Right(user);
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      await localDataSource.clearUser();
      await localDataSource.clearAuthToken();
      return const Right(null);
    } catch (e) {
      // Even if remote logout fails, clear local data
      await localDataSource.clearUser();
      await localDataSource.clearAuthToken();
      return const Right(null);
    }
  }
  
  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final user = await localDataSource.getCachedUser();
      return Right(user);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, bool>> isAuthenticated() async {
    try {
      final token = await localDataSource.getAuthToken();
      final user = await localDataSource.getCachedUser();
      return Right(token != null && user != null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }
}

