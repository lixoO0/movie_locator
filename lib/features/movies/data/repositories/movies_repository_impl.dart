import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/tv_show.dart';
import '../../domain/entities/genre.dart';
import '../../domain/repositories/movies_repository.dart';
import '../datasources/movies_remote_datasource.dart';

class MoviesRepositoryImpl implements MoviesRepository {
  final MoviesRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  
  const MoviesRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });
  
  @override
  Future<Either<Failure, List<Movie>>> getPopularMovies({int page = 1}) async {
    if (await networkInfo.isConnected) {
      try {
        final movies = await remoteDataSource.getPopularMovies(page: page);
        return Right(movies);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } catch (e) {
        return Left(UnknownFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }
  
  @override
  Future<Either<Failure, List<Movie>>> getTopRatedMovies({int page = 1}) async {
    if (await networkInfo.isConnected) {
      try {
        final movies = await remoteDataSource.getTopRatedMovies(page: page);
        return Right(movies);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } catch (e) {
        return Left(UnknownFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }
  
  @override
  Future<Either<Failure, List<Movie>>> getNowPlayingMovies({int page = 1}) async {
    if (await networkInfo.isConnected) {
      try {
        final movies = await remoteDataSource.getNowPlayingMovies(page: page);
        return Right(movies);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } catch (e) {
        return Left(UnknownFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }
  
  @override
  Future<Either<Failure, List<Movie>>> getUpcomingMovies({int page = 1}) async {
    if (await networkInfo.isConnected) {
      try {
        final movies = await remoteDataSource.getUpcomingMovies(page: page);
        return Right(movies);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } catch (e) {
        return Left(UnknownFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }
  
  @override
  Future<Either<Failure, Movie>> getMovieDetails(int movieId) async {
    if (await networkInfo.isConnected) {
      try {
        final movie = await remoteDataSource.getMovieDetails(movieId);
        return Right(movie);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } catch (e) {
        return Left(UnknownFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }
  
  @override
  Future<Either<Failure, List<Movie>>> searchMovies(String query, {int page = 1}) async {
    if (await networkInfo.isConnected) {
      try {
        final movies = await remoteDataSource.searchMovies(query, page: page);
        return Right(movies);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } catch (e) {
        return Left(UnknownFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }
  
  @override
  Future<Either<Failure, List<TvShow>>> getPopularTvShows({int page = 1}) async {
    if (await networkInfo.isConnected) {
      try {
        final tvShows = await remoteDataSource.getPopularTvShows(page: page);
        return Right(tvShows);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } catch (e) {
        return Left(UnknownFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }
  
  @override
  Future<Either<Failure, List<TvShow>>> getTopRatedTvShows({int page = 1}) async {
    if (await networkInfo.isConnected) {
      try {
        final tvShows = await remoteDataSource.getTopRatedTvShows(page: page);
        return Right(tvShows);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } catch (e) {
        return Left(UnknownFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }
  
  @override
  Future<Either<Failure, List<TvShow>>> getOnTheAirTvShows({int page = 1}) async {
    if (await networkInfo.isConnected) {
      try {
        final tvShows = await remoteDataSource.getOnTheAirTvShows(page: page);
        return Right(tvShows);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } catch (e) {
        return Left(UnknownFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }
  
  @override
  Future<Either<Failure, TvShow>> getTvShowDetails(int tvId) async {
    if (await networkInfo.isConnected) {
      try {
        final tvShow = await remoteDataSource.getTvShowDetails(tvId);
        return Right(tvShow);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } catch (e) {
        return Left(UnknownFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }
  
  @override
  Future<Either<Failure, List<TvShow>>> searchTvShows(String query, {int page = 1}) async {
    if (await networkInfo.isConnected) {
      try {
        final tvShows = await remoteDataSource.searchTvShows(query, page: page);
        return Right(tvShows);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } catch (e) {
        return Left(UnknownFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }
  
  @override
  Future<Either<Failure, List<Genre>>> getMovieGenres() async {
    if (await networkInfo.isConnected) {
      try {
        final genres = await remoteDataSource.getMovieGenres();
        return Right(genres);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } catch (e) {
        return Left(UnknownFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }
  
  @override
  Future<Either<Failure, List<Genre>>> getTvGenres() async {
    if (await networkInfo.isConnected) {
      try {
        final genres = await remoteDataSource.getTvGenres();
        return Right(genres);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } catch (e) {
        return Left(UnknownFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}
