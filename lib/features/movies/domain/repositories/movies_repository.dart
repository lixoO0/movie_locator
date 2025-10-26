import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/movie.dart';
import '../entities/tv_show.dart';
import '../entities/genre.dart';

abstract class MoviesRepository {
  Future<Either<Failure, List<Movie>>> getPopularMovies({int page = 1});
  Future<Either<Failure, List<Movie>>> getTopRatedMovies({int page = 1});
  Future<Either<Failure, List<Movie>>> getNowPlayingMovies({int page = 1});
  Future<Either<Failure, List<Movie>>> getUpcomingMovies({int page = 1});
  Future<Either<Failure, Movie>> getMovieDetails(int movieId);
  Future<Either<Failure, List<Movie>>> searchMovies(String query, {int page = 1});
  
  Future<Either<Failure, List<TvShow>>> getPopularTvShows({int page = 1});
  Future<Either<Failure, List<TvShow>>> getTopRatedTvShows({int page = 1});
  Future<Either<Failure, List<TvShow>>> getOnTheAirTvShows({int page = 1});
  Future<Either<Failure, TvShow>> getTvShowDetails(int tvId);
  Future<Either<Failure, List<TvShow>>> searchTvShows(String query, {int page = 1});
  
  Future<Either<Failure, List<Genre>>> getMovieGenres();
  Future<Either<Failure, List<Genre>>> getTvGenres();
}
