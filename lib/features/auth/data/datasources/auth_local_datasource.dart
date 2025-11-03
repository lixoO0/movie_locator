import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';
import 'dart:convert';
import '../../domain/entities/user.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(User user);
  Future<User?> getCachedUser();
  Future<void> clearUser();
  Future<void> cacheAuthToken(String token);
  Future<String?> getAuthToken();
  Future<void> clearAuthToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;
  
  static const String _userKey = 'CACHED_USER';
  static const String _tokenKey = 'AUTH_TOKEN';
  
  AuthLocalDataSourceImpl({required this.secureStorage});
  
  @override
  Future<void> cacheUser(User user) async {
    try {
      final userJson = jsonEncode(UserModel.fromEntity(user).toJson());
      await secureStorage.write(
        key: _userKey, 
        value: userJson,
      ).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw TimeoutException('Failed to cache user: operation timed out');
        },
      );
    } catch (e) {
      // Re-throw to be handled by repository
      throw Exception('Failed to cache user: $e');
    }
  }
  
  @override
  Future<User?> getCachedUser() async {
    try {
      final userJson = await secureStorage.read(key: _userKey);
      if (userJson != null) {
        final userMap = jsonDecode(userJson) as Map<String, dynamic>;
        return UserModel.fromJson(userMap);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
  
  @override
  Future<void> clearUser() async {
    await secureStorage.delete(key: _userKey);
  }
  
  @override
  Future<void> cacheAuthToken(String token) async {
    try {
      await secureStorage.write(
        key: _tokenKey, 
        value: token,
      ).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw TimeoutException('Failed to cache token: operation timed out');
        },
      );
    } catch (e) {
      // Re-throw to be handled by repository
      throw Exception('Failed to cache token: $e');
    }
  }
  
  @override
  Future<String?> getAuthToken() async {
    return await secureStorage.read(key: _tokenKey);
  }
  
  @override
  Future<void> clearAuthToken() async {
    await secureStorage.delete(key: _tokenKey);
  }
}

