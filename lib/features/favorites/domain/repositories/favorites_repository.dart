import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/favorite_movie.dart';

abstract class FavoritesRepository {
  Future<Either<Failure, List<FavoriteMovie>>> getFavorites();
  Future<Either<Failure, void>> addFavorite(FavoriteMovie favorite);
  Future<Either<Failure, void>> removeFavorite(int id);
  Future<Either<Failure, bool>> isFavorite(int id);
}

