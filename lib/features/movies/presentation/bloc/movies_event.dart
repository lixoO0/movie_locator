import 'package:equatable/equatable.dart';

abstract class MoviesEvent extends Equatable {
  const MoviesEvent();
  
  @override
  List<Object?> get props => [];
}

class GetPopularMoviesEvent extends MoviesEvent {
  final int page;
  
  const GetPopularMoviesEvent({this.page = 1});
  
  @override
  List<Object?> get props => [page];
}

class GetTopRatedMoviesEvent extends MoviesEvent {
  final int page;
  
  const GetTopRatedMoviesEvent({this.page = 1});
  
  @override
  List<Object?> get props => [page];
}

class GetNowPlayingMoviesEvent extends MoviesEvent {
  final int page;
  
  const GetNowPlayingMoviesEvent({this.page = 1});
  
  @override
  List<Object?> get props => [page];
}

class GetUpcomingMoviesEvent extends MoviesEvent {
  final int page;
  
  const GetUpcomingMoviesEvent({this.page = 1});
  
  @override
  List<Object?> get props => [page];
}

class GetMovieDetailsEvent extends MoviesEvent {
  final int movieId;
  
  const GetMovieDetailsEvent({required this.movieId});
  
  @override
  List<Object?> get props => [movieId];
}

class SearchMoviesEvent extends MoviesEvent {
  final String query;
  final int page;
  
  const SearchMoviesEvent({
    required this.query,
    this.page = 1,
  });
  
  @override
  List<Object?> get props => [query, page];
}

class GetMovieGenresEvent extends MoviesEvent {
  const GetMovieGenresEvent();
}

class DiscoverMoviesEvent extends MoviesEvent {
  final int? genreId;
  final int? year;
  final double? minRating;
  final int page;
  
  const DiscoverMoviesEvent({
    this.genreId,
    this.year,
    this.minRating,
    this.page = 1,
  });
  
  @override
  List<Object?> get props => [genreId, year, minRating, page];
}

class GetMovieVideosEvent extends MoviesEvent {
  final int movieId;
  
  const GetMovieVideosEvent({required this.movieId});
  
  @override
  List<Object?> get props => [movieId];
}

class GetPopularTvShowsEvent extends MoviesEvent {
  final int page;
  
  const GetPopularTvShowsEvent({this.page = 1});
  
  @override
  List<Object?> get props => [page];
}

class DiscoverTvShowsEvent extends MoviesEvent {
  final int? genreId;
  final int? year;
  final double? minRating;
  final int page;
  
  const DiscoverTvShowsEvent({
    this.genreId,
    this.year,
    this.minRating,
    this.page = 1,
  });
  
  @override
  List<Object?> get props => [genreId, year, minRating, page];
}

class GetTvShowDetailsEvent extends MoviesEvent {
  final int tvId;
  
  const GetTvShowDetailsEvent({required this.tvId});
  
  @override
  List<Object?> get props => [tvId];
}

class GetTvShowVideosEvent extends MoviesEvent {
  final int tvId;
  
  const GetTvShowVideosEvent({required this.tvId});
  
  @override
  List<Object?> get props => [tvId];
}