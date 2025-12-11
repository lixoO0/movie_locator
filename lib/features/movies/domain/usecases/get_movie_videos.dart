import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/video.dart';
import '../repositories/movies_repository.dart';

class GetMovieVideos implements UseCase<List<Video>, GetMovieVideosParams> {
  final MoviesRepository repository;
  
  const GetMovieVideos(this.repository);
  
  @override
  Future<Either<Failure, List<Video>>> call(GetMovieVideosParams params) async {
    return await repository.getMovieVideos(params.movieId);
  }
}

class GetMovieVideosParams extends Equatable {
  final int movieId;
  
  const GetMovieVideosParams({required this.movieId});
  
  @override
  List<Object> get props => [movieId];
}

