import 'package:dio/dio.dart';
import '../../domain/entities/user.dart';
import '../../../../core/errors/exceptions.dart' show ServerException, AuthenticationException;
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<User> login(String email, String password);
  Future<User> register(String email, String password, String displayName);
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  
  // Mock API endpoint - in production, replace with real auth API
  static const String _baseUrl = 'https://api.example.com/auth';
  
  AuthRemoteDataSourceImpl({required this.dio});
  
  @override
  Future<User> login(String email, String password) async {
    try {
      // Mock implementation - replace with real API call
      // For now, simulate a successful login
      await Future.delayed(const Duration(milliseconds: 300));
      
      // In production, make actual API call:
      // final response = await dio.post(
      //   '$_baseUrl/login',
      //   data: {'email': email, 'password': password},
      // );
      
      // Mock user response
      final user = UserModel(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        displayName: email.split('@')[0],
      );
      
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw AuthenticationException(message: 'Invalid email or password');
      }
      throw ServerException(message: e.message ?? 'Login failed');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
  
  @override
  Future<User> register(String email, String password, String displayName) async {
    try {
      // Mock implementation - replace with real API call
      await Future.delayed(const Duration(milliseconds: 300));
      
      // In production, make actual API call:
      // final response = await dio.post(
      //   '$_baseUrl/register',
      //   data: {
      //     'email': email,
      //     'password': password,
      //     'displayName': displayName,
      //   },
      // );
      
      // Mock user response
      final user = UserModel(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        displayName: displayName,
      );
      
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        throw AuthenticationException(message: 'Email already exists');
      }
      throw ServerException(message: e.message ?? 'Registration failed');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
  
  @override
  Future<void> logout() async {
    try {
      // Mock implementation
      await Future.delayed(const Duration(milliseconds: 500));
      
      // In production:
      // await dio.post('$_baseUrl/logout');
    } catch (e) {
      // Silent fail for logout
    }
  }
}

