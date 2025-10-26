import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/movie.dart';
import '../repositories/movies_repository.dart';

class GetTopRatedMovies implements UseCase<List<Movie>, GetTopRatedMoviesParams> {
  final MoviesRepository repository;
  
  const GetTopRatedMovies(this.repository);
  
  @override
  Future<Either<Failure, List<Movie>>> call(GetTopRatedMoviesParams params) async {
    return await repository.getTopRatedMovies(page: params.page);
  }
}

class GetTopRatedMoviesParams extends Equatable {
  final int page;
  
  const GetTopRatedMoviesParams({this.page = 1});
  
  @override
  List<Object> get props => [page];
}
