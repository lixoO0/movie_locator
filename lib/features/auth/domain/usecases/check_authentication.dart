import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class CheckAuthentication implements UseCaseNoParams<bool> {
  final AuthRepository repository;
  
  CheckAuthentication(this.repository);
  
  @override
  Future<Either<Failure, bool>> call() async {
    return await repository.isAuthenticated();
  }
}

