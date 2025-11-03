import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../domain/entities/movie.dart';

// Import generated types after build_runner
// This will work after running: flutter pub run build_runner build

abstract class MoviesLocalDataSource {
  Future<List<Movie>> getCachedMovies(String category);
  Future<void> cacheMovies(List<Movie> movies, String category);
  Future<Movie?> getCachedMovieDetails(int movieId);
  Future<void> cacheMovieDetails(Movie movie);
  Future<void> clearCache(String category);
  Future<void> clearAllCache();
}

class MoviesLocalDataSourceImpl implements MoviesLocalDataSource {
  final AppDatabase database;

  MoviesLocalDataSourceImpl({required this.database});

  @override
  Future<List<Movie>> getCachedMovies(String category) async {
    try {
      final cachedMovies = await database.getMoviesByCategory(category);
      return cachedMovies.map<Movie>((dbMovie) => Movie(
        id: dbMovie.id,
        title: dbMovie.title,
        overview: dbMovie.overview,
        voteAverage: dbMovie.voteAverage,
        voteCount: dbMovie.voteCount,
        releaseDate: dbMovie.releaseDate,
        posterPath: dbMovie.posterPath,
        backdropPath: dbMovie.backdropPath,
        originalLanguage: dbMovie.originalLanguage,
        originalTitle: dbMovie.originalTitle,
        adult: dbMovie.adult,
        video: dbMovie.video,
        popularity: dbMovie.popularity,
        genreIds: const [], // Will be empty for cached movies
      )).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> cacheMovies(List<Movie> movies, String category) async {
    try {
      final companions = movies.map((movie) => MoviesCompanion(
        id: Value(movie.id),
        title: Value(movie.title),
        overview: Value(movie.overview),
        voteAverage: Value(movie.voteAverage),
        voteCount: Value(movie.voteCount),
        releaseDate: Value(movie.releaseDate),
        posterPath: Value(movie.posterPath),
        backdropPath: Value(movie.backdropPath),
        originalLanguage: Value(movie.originalLanguage),
        originalTitle: Value(movie.originalTitle),
        adult: Value(movie.adult),
        video: Value(movie.video),
        popularity: Value(movie.popularity),
        cachedAt: Value(DateTime.now()),
        category: Value(category),
      )).toList();
      
      await database.insertMovies(companions);
    } catch (e) {
      // Silent fail for caching
    }
  }

  @override
  Future<Movie?> getCachedMovieDetails(int movieId) async {
    try {
      final dbMovie = await database.getMovieById(movieId);
      if (dbMovie == null) return null;
      
      return Movie(
        id: dbMovie.id,
        title: dbMovie.title,
        overview: dbMovie.overview,
        voteAverage: dbMovie.voteAverage,
        voteCount: dbMovie.voteCount,
        releaseDate: dbMovie.releaseDate,
        posterPath: dbMovie.posterPath,
        backdropPath: dbMovie.backdropPath,
        originalLanguage: dbMovie.originalLanguage,
        originalTitle: dbMovie.originalTitle,
        adult: dbMovie.adult,
        video: dbMovie.video,
        popularity: dbMovie.popularity,
        genreIds: const [], // Will be empty for cached movies
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cacheMovieDetails(Movie movie) async {
    await cacheMovies([movie], 'details');
  }

  @override
  Future<void> clearCache(String category) async {
    await database.clearMoviesByCategory(category);
  }

  @override
  Future<void> clearAllCache() async {
    await database.clearAllMovies();
  }
}

