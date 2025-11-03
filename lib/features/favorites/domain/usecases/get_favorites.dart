import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/favorite_movie.dart';
import '../repositories/favorites_repository.dart';

class GetFavorites implements UseCaseNoParams<List<FavoriteMovie>> {
  final FavoritesRepository repository;
  
  GetFavorites(this.repository);
  
  @override
  Future<Either<Failure, List<FavoriteMovie>>> call() async {
    return await repository.getFavorites();
  }
}

