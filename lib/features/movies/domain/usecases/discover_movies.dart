import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/movie.dart';
import '../repositories/movies_repository.dart';

class DiscoverMovies implements UseCase<List<Movie>, DiscoverMoviesParams> {
  final MoviesRepository repository;
  
  const DiscoverMovies(this.repository);
  
  @override
  Future<Either<Failure, List<Movie>>> call(DiscoverMoviesParams params) async {
    return await repository.discoverMovies(
      genreId: params.genreId,
      year: params.year,
      minRating: params.minRating,
      page: params.page,
    );
  }
}

class DiscoverMoviesParams extends Equatable {
  final int? genreId;
  final int? year;
  final double? minRating;
  final int page;
  
  const DiscoverMoviesParams({
    this.genreId,
    this.year,
    this.minRating,
    this.page = 1,
  });
  
  @override
  List<Object?> get props => [genreId, year, minRating, page];
}

