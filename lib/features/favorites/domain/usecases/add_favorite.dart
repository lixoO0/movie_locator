import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/favorite_movie.dart';
import '../repositories/favorites_repository.dart';

class AddFavorite implements UseCase<void, AddFavoriteParams> {
  final FavoritesRepository repository;
  
  AddFavorite(this.repository);
  
  @override
  Future<Either<Failure, void>> call(AddFavoriteParams params) async {
    return await repository.addFavorite(params.favorite);
  }
}

class AddFavoriteParams extends Equatable {
  final FavoriteMovie favorite;
  
  const AddFavoriteParams({required this.favorite});
  
  @override
  List<Object> get props => [favorite];
}

