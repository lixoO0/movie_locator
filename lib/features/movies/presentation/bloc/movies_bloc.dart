import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_popular_movies.dart';
import '../../domain/usecases/get_top_rated_movies.dart';
import '../../domain/usecases/get_movie_details.dart';
import '../../domain/usecases/search_movies.dart';
import '../../domain/usecases/get_movie_genres.dart';
import 'movies_event.dart';
import 'movies_state.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  final GetPopularMovies getPopularMovies;
  final GetTopRatedMovies getTopRatedMovies;
  final GetMovieDetails getMovieDetails;
  final SearchMovies searchMovies;
  final GetMovieGenres getMovieGenres;
  
  MoviesBloc({
    required this.getPopularMovies,
    required this.getTopRatedMovies,
    required this.getMovieDetails,
    required this.searchMovies,
    required this.getMovieGenres,
  }) : super(MoviesInitial()) {
    on<GetPopularMoviesEvent>(_onGetPopularMovies);
    on<GetTopRatedMoviesEvent>(_onGetTopRatedMovies);
    on<GetNowPlayingMoviesEvent>(_onGetNowPlayingMovies);
    on<GetUpcomingMoviesEvent>(_onGetUpcomingMovies);
    on<GetMovieDetailsEvent>(_onGetMovieDetails);
    on<SearchMoviesEvent>(_onSearchMovies);
    on<GetMovieGenresEvent>(_onGetMovieGenres);
  }
  
  Future<void> _onGetPopularMovies(
    GetPopularMoviesEvent event,
    Emitter<MoviesState> emit,
  ) async {
    if (state is MoviesLoaded) {
      final currentState = state as MoviesLoaded;
      if (currentState.hasReachedMax) return;
    }
    
    emit(MoviesLoading());
    
    final result = await getPopularMovies(GetPopularMoviesParams(page: event.page));
    
    result.fold(
      (failure) => emit(MoviesError(message: failure.message)),
      (movies) {
        if (state is MoviesLoaded) {
          final currentState = state as MoviesLoaded;
          final allMovies = [...currentState.movies, ...movies];
          emit(MoviesLoaded(
            movies: allMovies,
            hasReachedMax: movies.length < 20,
            currentPage: event.page,
          ));
        } else {
          emit(MoviesLoaded(
            movies: movies,
            hasReachedMax: movies.length < 20,
            currentPage: event.page,
          ));
        }
      },
    );
  }
  
  Future<void> _onGetTopRatedMovies(
    GetTopRatedMoviesEvent event,
    Emitter<MoviesState> emit,
  ) async {
    emit(MoviesLoading());
    
    final result = await getTopRatedMovies(GetTopRatedMoviesParams(page: event.page));
    
    result.fold(
      (failure) => emit(MoviesError(message: failure.message)),
      (movies) => emit(MoviesLoaded(
        movies: movies,
        hasReachedMax: movies.length < 20,
        currentPage: event.page,
      )),
    );
  }
  
  Future<void> _onGetNowPlayingMovies(
    GetNowPlayingMoviesEvent event,
    Emitter<MoviesState> emit,
  ) async {
    emit(MoviesLoading());
    
    // For now, we'll use popular movies as a placeholder
    // You can implement specific use case for now playing movies
    final result = await getPopularMovies(GetPopularMoviesParams(page: event.page));
    
    result.fold(
      (failure) => emit(MoviesError(message: failure.message)),
      (movies) => emit(MoviesLoaded(
        movies: movies,
        hasReachedMax: movies.length < 20,
        currentPage: event.page,
      )),
    );
  }
  
  Future<void> _onGetUpcomingMovies(
    GetUpcomingMoviesEvent event,
    Emitter<MoviesState> emit,
  ) async {
    emit(MoviesLoading());
    
    // For now, we'll use top rated movies as a placeholder
    // You can implement specific use case for upcoming movies
    final result = await getTopRatedMovies(GetTopRatedMoviesParams(page: event.page));
    
    result.fold(
      (failure) => emit(MoviesError(message: failure.message)),
      (movies) => emit(MoviesLoaded(
        movies: movies,
        hasReachedMax: movies.length < 20,
        currentPage: event.page,
      )),
    );
  }
  
  Future<void> _onGetMovieDetails(
    GetMovieDetailsEvent event,
    Emitter<MoviesState> emit,
  ) async {
    emit(MovieDetailsLoading());
    
    final result = await getMovieDetails(GetMovieDetailsParams(movieId: event.movieId));
    
    result.fold(
      (failure) => emit(MovieDetailsError(message: failure.message)),
      (movie) => emit(MovieDetailsLoaded(movie: movie)),
    );
  }
  
  Future<void> _onSearchMovies(
    SearchMoviesEvent event,
    Emitter<MoviesState> emit,
  ) async {
    emit(MoviesLoading());
    
    final result = await searchMovies(SearchMoviesParams(
      query: event.query,
      page: event.page,
    ));
    
    result.fold(
      (failure) => emit(MoviesError(message: failure.message)),
      (movies) => emit(MoviesLoaded(
        movies: movies,
        hasReachedMax: movies.length < 20,
        currentPage: event.page,
      )),
    );
  }
  
  Future<void> _onGetMovieGenres(
    GetMovieGenresEvent event,
    Emitter<MoviesState> emit,
  ) async {
    emit(GenresLoading());
    
    final result = await getMovieGenres();
    
    result.fold(
      (failure) => emit(GenresError(message: failure.message)),
      (genres) => emit(GenresLoaded(genres: genres)),
    );
  }
}
