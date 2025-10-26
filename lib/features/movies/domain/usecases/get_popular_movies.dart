import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/movie.dart';
import '../repositories/movies_repository.dart';

class GetPopularMovies implements UseCase<List<Movie>, GetPopularMoviesParams> {
  final MoviesRepository repository;
  
  const GetPopularMovies(this.repository);
  
  @override
  Future<Either<Failure, List<Movie>>> call(GetPopularMoviesParams params) async {
    return await repository.getPopularMovies(page: params.page);
  }
}

class GetPopularMoviesParams extends Equatable {
  final int page;
  
  const GetPopularMoviesParams({this.page = 1});
  
  @override
  List<Object> get props => [page];
}
