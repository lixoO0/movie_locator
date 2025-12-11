import 'package:equatable/equatable.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/tv_show.dart';
import '../../domain/entities/genre.dart';
import '../../domain/entities/video.dart';

abstract class MoviesState extends Equatable {
  const MoviesState();
  
  @override
  List<Object?> get props => [];
}

class MoviesInitial extends MoviesState {}

class MoviesLoading extends MoviesState {}

class MoviesLoaded extends MoviesState {
  final List<Movie> movies;
  final bool hasReachedMax;
  final int currentPage;
  
  const MoviesLoaded({
    required this.movies,
    this.hasReachedMax = false,
    this.currentPage = 1,
  });
  
  MoviesLoaded copyWith({
    List<Movie>? movies,
    bool? hasReachedMax,
    int? currentPage,
  }) {
    return MoviesLoaded(
      movies: movies ?? this.movies,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
    );
  }
  
  @override
  List<Object?> get props => [movies, hasReachedMax, currentPage];
}

class MoviesError extends MoviesState {
  final String message;
  
  const MoviesError({required this.message});
  
  @override
  List<Object> get props => [message];
}

class MovieDetailsLoading extends MoviesState {}

class MovieDetailsLoaded extends MoviesState {
  final Movie movie;
  
  const MovieDetailsLoaded({required this.movie});
  
  @override
  List<Object> get props => [movie];
}

class MovieDetailsError extends MoviesState {
  final String message;
  
  const MovieDetailsError({required this.message});
  
  @override
  List<Object> get props => [message];
}

class GenresLoading extends MoviesState {}

class GenresLoaded extends MoviesState {
  final List<Genre> genres;
  
  const GenresLoaded({required this.genres});
  
  @override
  List<Object> get props => [genres];
}

class GenresError extends MoviesState {
  final String message;
  
  const GenresError({required this.message});
  
  @override
  List<Object> get props => [message];
}

class VideosLoading extends MoviesState {}

class VideosLoaded extends MoviesState {
  final List<Video> videos;
  
  const VideosLoaded({required this.videos});
  
  @override
  List<Object> get props => [videos];
}

class VideosError extends MoviesState {
  final String message;
  
  const VideosError({required this.message});
  
  @override
  List<Object> get props => [message];
}

class TvShowsLoaded extends MoviesState {
  final List<TvShow> tvShows;
  final bool hasReachedMax;
  final int currentPage;
  
  const TvShowsLoaded({
    required this.tvShows,
    this.hasReachedMax = false,
    this.currentPage = 1,
  });
  
  @override
  List<Object?> get props => [tvShows, hasReachedMax, currentPage];
}

class TvShowDetailsLoading extends MoviesState {}

class TvShowDetailsLoaded extends MoviesState {
  final TvShow tvShow;
  
  const TvShowDetailsLoaded({required this.tvShow});
  
  @override
  List<Object> get props => [tvShow];
}

class TvShowDetailsError extends MoviesState {
  final String message;
  
  const TvShowDetailsError({required this.message});
  
  @override
  List<Object> get props => [message];
}