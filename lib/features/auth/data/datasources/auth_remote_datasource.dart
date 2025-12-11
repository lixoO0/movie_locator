import 'package:dio/dio.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../../domain/entities/user.dart' as auth_entity;
import '../../../../core/errors/exceptions.dart' show ServerException, AuthenticationException;
import '../../../../core/database/app_database.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<auth_entity.User> login(String email, String password);
  Future<auth_entity.User> register(String email, String password, String displayName);
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  final AppDatabase database;
  
  AuthRemoteDataSourceImpl({
    required this.dio,
    required this.database,
  });
  
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
  
  @override
  Future<auth_entity.User> login(String email, String password) async {
    try {
      // Check user in database
      final dbUser = await database.getUserByEmail(email);
      
      if (dbUser == null) {
        throw AuthenticationException(message: 'Користувач з таким email не знайдений');
      }
      
      // Verify password
      final passwordHash = _hashPassword(password);
      if (dbUser.passwordHash != passwordHash) {
        throw AuthenticationException(message: 'Невірний пароль');
      }
      
      // Return user entity
      return UserModel(
        id: dbUser.id,
        email: dbUser.email,
        displayName: dbUser.displayName,
      );
    } on AuthenticationException {
      rethrow;
    } catch (e) {
      if (e is AuthenticationException) {
        rethrow;
      }
      throw ServerException(message: e.toString());
    }
  }
  
  @override
  Future<auth_entity.User> register(String email, String password, String displayName) async {
    try {
      // Check if user already exists
      final existingUser = await database.getUserByEmail(email);
      if (existingUser != null) {
        throw AuthenticationException(message: 'Користувач з таким email вже існує');
      }
      
      // Hash password
      final passwordHash = _hashPassword(password);
      
      // Create user ID
      final userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
      
      // Save user to database
      await database.insertUser(
        UsersCompanion.insert(
          id: userId,
          email: email,
          displayName: displayName,
          passwordHash: passwordHash,
          createdAt: DateTime.now(),
        ),
      );
      
      // Return user entity
      return UserModel(
        id: userId,
        email: email,
        displayName: displayName,
      );
    } on AuthenticationException {
      rethrow;
    } catch (e) {
      if (e is AuthenticationException) {
        rethrow;
      }
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

