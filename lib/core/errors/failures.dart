import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure([List properties = const <dynamic>[]]);
  
  @override
  List<Object> get props => [];
}

// General failures
class ServerFailure extends Failure {
  final String message;
  
  const ServerFailure({this.message = 'Server error occurred'});
  
  @override
  List<Object> get props => [message];
}

class NetworkFailure extends Failure {
  final String message;
  
  const NetworkFailure({this.message = 'Network connection error'});
  
  @override
  List<Object> get props => [message];
}

class CacheFailure extends Failure {
  final String message;
  
  const CacheFailure({this.message = 'Cache error occurred'});
  
  @override
  List<Object> get props => [message];
}

class ValidationFailure extends Failure {
  final String message;
  
  const ValidationFailure({this.message = 'Validation error occurred'});
  
  @override
  List<Object> get props => [message];
}

class AuthenticationFailure extends Failure {
  final String message;
  
  const AuthenticationFailure({this.message = 'Authentication failed'});
  
  @override
  List<Object> get props => [message];
}

class PermissionFailure extends Failure {
  final String message;
  
  const PermissionFailure({this.message = 'Permission denied'});
  
  @override
  List<Object> get props => [message];
}

class UnknownFailure extends Failure {
  final String message;
  
  const UnknownFailure({this.message = 'Unknown error occurred'});
  
  @override
  List<Object> get props => [message];
}
