import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/tv_show.dart';
import '../repositories/movies_repository.dart';

class GetTvShowDetails implements UseCase<TvShow, GetTvShowDetailsParams> {
  final MoviesRepository repository;
  
  const GetTvShowDetails(this.repository);
  
  @override
  Future<Either<Failure, TvShow>> call(GetTvShowDetailsParams params) async {
    return await repository.getTvShowDetails(params.tvId);
  }
}

class GetTvShowDetailsParams extends Equatable {
  final int tvId;
  
  const GetTvShowDetailsParams({required this.tvId});
  
  @override
  List<Object> get props => [tvId];
}

