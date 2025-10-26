import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/genre.dart';
import '../repositories/movies_repository.dart';

class GetMovieGenres implements UseCaseNoParams<List<Genre>> {
  final MoviesRepository repository;
  
  const GetMovieGenres(this.repository);
  
  @override
  Future<Either<Failure, List<Genre>>> call() async {
    return await repository.getMovieGenres();
  }
}
