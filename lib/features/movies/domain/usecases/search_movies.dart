import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/movie.dart';
import '../repositories/movies_repository.dart';

class SearchMovies implements UseCase<List<Movie>, SearchMoviesParams> {
  final MoviesRepository repository;
  
  const SearchMovies(this.repository);
  
  @override
  Future<Either<Failure, List<Movie>>> call(SearchMoviesParams params) async {
    return await repository.searchMovies(params.query, page: params.page);
  }
}

class SearchMoviesParams extends Equatable {
  final String query;
  final int page;
  
  const SearchMoviesParams({
    required this.query,
    this.page = 1,
  });
  
  @override
  List<Object> get props => [query, page];
}
