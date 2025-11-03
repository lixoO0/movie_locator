import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/database/app_database.dart';
import '../../domain/entities/favorite_movie.dart';
import '../../domain/repositories/favorites_repository.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final AppDatabase database;
  
  FavoritesRepositoryImpl({required this.database});
  
  @override
  Future<Either<Failure, List<FavoriteMovie>>> getFavorites() async {
    try {
      final favorites = await database.getAllFavorites();
      return Right(favorites.map((f) => FavoriteMovie(
        id: f.id,
        title: f.title,
        overview: f.overview,
        voteAverage: f.voteAverage,
        posterPath: f.posterPath,
        type: f.type,
        addedAt: f.addedAt,
      )).toList());
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, void>> addFavorite(FavoriteMovie favorite) async {
    try {
      await database.insertFavorite(FavoritesCompanion(
        id: Value(favorite.id),
        title: Value(favorite.title),
        overview: Value(favorite.overview),
        voteAverage: Value(favorite.voteAverage),
        posterPath: Value(favorite.posterPath),
        type: Value(favorite.type),
        addedAt: Value(favorite.addedAt),
      ));
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, void>> removeFavorite(int id) async {
    try {
      await database.deleteFavorite(id);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, bool>> isFavorite(int id) async {
    try {
      final result = await database.isFavorite(id);
      return Right(result);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }
}

