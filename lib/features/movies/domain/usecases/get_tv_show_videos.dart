import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/video.dart';
import '../repositories/movies_repository.dart';

class GetTvShowVideos implements UseCase<List<Video>, GetTvShowVideosParams> {
  final MoviesRepository repository;
  
  const GetTvShowVideos(this.repository);
  
  @override
  Future<Either<Failure, List<Video>>> call(GetTvShowVideosParams params) async {
    return await repository.getTvShowVideos(params.tvId);
  }
}

class GetTvShowVideosParams extends Equatable {
  final int tvId;
  
  const GetTvShowVideosParams({required this.tvId});
  
  @override
  List<Object> get props => [tvId];
}

