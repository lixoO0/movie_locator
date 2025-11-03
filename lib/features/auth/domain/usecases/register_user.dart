import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterUser implements UseCase<User, RegisterUserParams> {
  final AuthRepository repository;
  
  RegisterUser(this.repository);
  
  @override
  Future<Either<Failure, User>> call(RegisterUserParams params) async {
    return await repository.register(
      params.email,
      params.password,
      params.displayName,
    );
  }
}

class RegisterUserParams extends Equatable {
  final String email;
  final String password;
  final String displayName;
  
  const RegisterUserParams({
    required this.email,
    required this.password,
    required this.displayName,
  });
  
  @override
  List<Object> get props => [email, password, displayName];
}

