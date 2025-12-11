import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/tv_show.dart';
import '../repositories/movies_repository.dart';

class GetPopularTvShows implements UseCase<List<TvShow>, GetPopularTvShowsParams> {
  final MoviesRepository repository;
  
  const GetPopularTvShows(this.repository);
  
  @override
  Future<Either<Failure, List<TvShow>>> call(GetPopularTvShowsParams params) async {
    return await repository.getPopularTvShows(page: params.page);
  }
}

class GetPopularTvShowsParams extends Equatable {
  final int page;
  
  const GetPopularTvShowsParams({this.page = 1});
  
  @override
  List<Object> get props => [page];
}

