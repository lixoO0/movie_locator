import 'package:equatable/equatable.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/genre.dart';

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
