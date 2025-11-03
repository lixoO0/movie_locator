import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/favorites_repository.dart';

class RemoveFavorite implements UseCase<void, RemoveFavoriteParams> {
  final FavoritesRepository repository;
  
  RemoveFavorite(this.repository);
  
  @override
  Future<Either<Failure, void>> call(RemoveFavoriteParams params) async {
    return await repository.removeFavorite(params.id);
  }
}

class RemoveFavoriteParams extends Equatable {
  final int id;
  
  const RemoveFavoriteParams({required this.id});
  
  @override
  List<Object> get props => [id];
}

