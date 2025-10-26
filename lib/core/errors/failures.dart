import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  
  const Failure({this.message = 'An error occurred'});
  
  @override
  List<Object> get props => [message];
}

// General failures
class ServerFailure extends Failure {
  const ServerFailure({super.message = 'Server error occurred'});
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'Network connection error'});
}

class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Cache error occurred'});
}

class ValidationFailure extends Failure {
  const ValidationFailure({super.message = 'Validation error occurred'});
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure({super.message = 'Authentication failed'});
}

class PermissionFailure extends Failure {
  const PermissionFailure({super.message = 'Permission denied'});
}

class UnknownFailure extends Failure {
  const UnknownFailure({super.message = 'Unknown error occurred'});
}
