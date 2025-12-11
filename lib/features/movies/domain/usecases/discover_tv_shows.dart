import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/tv_show.dart';
import '../repositories/movies_repository.dart';

class DiscoverTvShows implements UseCase<List<TvShow>, DiscoverTvShowsParams> {
  final MoviesRepository repository;
  
  const DiscoverTvShows(this.repository);
  
  @override
  Future<Either<Failure, List<TvShow>>> call(DiscoverTvShowsParams params) async {
    return await repository.discoverTvShows(
      genreId: params.genreId,
      year: params.year,
      minRating: params.minRating,
      page: params.page,
    );
  }
}

class DiscoverTvShowsParams extends Equatable {
  final int? genreId;
  final int? year;
  final double? minRating;
  final int page;
  
  const DiscoverTvShowsParams({
    this.genreId,
    this.year,
    this.minRating,
    this.page = 1,
  });
  
  @override
  List<Object?> get props => [genreId, year, minRating, page];
}

