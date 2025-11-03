import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/favorites_repository.dart';

class CheckIsFavorite implements UseCase<bool, CheckIsFavoriteParams> {
  final FavoritesRepository repository;
  
  CheckIsFavorite(this.repository);
  
  @override
  Future<Either<Failure, bool>> call(CheckIsFavoriteParams params) async {
    return await repository.isFavorite(params.id);
  }
}

class CheckIsFavoriteParams extends Equatable {
  final int id;
  
  const CheckIsFavoriteParams({required this.id});
  
  @override
  List<Object> get props => [id];
}

