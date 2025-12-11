import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_popular_movies.dart';
import '../../domain/usecases/get_top_rated_movies.dart';
import '../../domain/usecases/get_movie_details.dart';
import '../../domain/usecases/search_movies.dart';
import '../../domain/usecases/get_movie_genres.dart';
import '../../domain/usecases/discover_movies.dart';
import '../../domain/usecases/get_movie_videos.dart';
import '../../domain/usecases/get_popular_tv_shows.dart';
import '../../domain/usecases/discover_tv_shows.dart';
import '../../domain/usecases/get_tv_show_details.dart';
import '../../domain/usecases/get_tv_show_videos.dart';
import 'movies_event.dart';
import 'movies_state.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  final GetPopularMovies getPopularMovies;
  final GetTopRatedMovies getTopRatedMovies;
  final GetMovieDetails getMovieDetails;
  final SearchMovies searchMovies;
  final GetMovieGenres getMovieGenres;
  final DiscoverMovies discoverMovies;
  final GetMovieVideos getMovieVideos;
  final GetPopularTvShows getPopularTvShows;
  final DiscoverTvShows discoverTvShows;
  final GetTvShowDetails getTvShowDetails;
  final GetTvShowVideos getTvShowVideos;
  
  MoviesBloc({
    required this.getPopularMovies,
    required this.getTopRatedMovies,
    required this.getMovieDetails,
    required this.searchMovies,
    required this.getMovieGenres,
    required this.discoverMovies,
    required this.getMovieVideos,
    required this.getPopularTvShows,
    required this.discoverTvShows,
    required this.getTvShowDetails,
    required this.getTvShowVideos,
  }) : super(MoviesInitial()) {
    on<GetPopularMoviesEvent>(_onGetPopularMovies);
    on<GetTopRatedMoviesEvent>(_onGetTopRatedMovies);
    on<GetNowPlayingMoviesEvent>(_onGetNowPlayingMovies);
    on<GetUpcomingMoviesEvent>(_onGetUpcomingMovies);
    on<GetMovieDetailsEvent>(_onGetMovieDetails);
    on<SearchMoviesEvent>(_onSearchMovies);
    on<GetMovieGenresEvent>(_onGetMovieGenres);
    on<DiscoverMoviesEvent>(_onDiscoverMovies);
    on<GetMovieVideosEvent>(_onGetMovieVideos);
    on<GetPopularTvShowsEvent>(_onGetPopularTvShows);
    on<DiscoverTvShowsEvent>(_onDiscoverTvShows);
    on<GetTvShowDetailsEvent>(_onGetTvShowDetails);
    on<GetTvShowVideosEvent>(_onGetTvShowVideos);
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
  
  Future<void> _onDiscoverMovies(
    DiscoverMoviesEvent event,
    Emitter<MoviesState> emit,
  ) async {
    // If page is 1, reset the list. Otherwise, append to existing list
    if (event.page == 1) {
      emit(MoviesLoading());
    }
    
    final result = await discoverMovies(DiscoverMoviesParams(
      genreId: event.genreId,
      year: event.year,
      minRating: event.minRating,
      page: event.page,
    ));
    
    result.fold(
      (failure) => emit(MoviesError(message: failure.message)),
      (movies) {
        if (event.page == 1) {
          // First page - replace the list
          emit(MoviesLoaded(
            movies: movies,
            hasReachedMax: movies.length < 20,
            currentPage: event.page,
          ));
        } else {
          // Subsequent pages - append to existing list
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
        }
      },
    );
  }
  
  Future<void> _onGetMovieVideos(
    GetMovieVideosEvent event,
    Emitter<MoviesState> emit,
  ) async {
    emit(VideosLoading());
    
    final result = await getMovieVideos(GetMovieVideosParams(movieId: event.movieId));
    
    result.fold(
      (failure) => emit(VideosError(message: failure.message)),
      (videos) => emit(VideosLoaded(videos: videos)),
    );
  }
  
  Future<void> _onGetPopularTvShows(
    GetPopularTvShowsEvent event,
    Emitter<MoviesState> emit,
  ) async {
    emit(MoviesLoading());
    
    final result = await getPopularTvShows(GetPopularTvShowsParams(page: event.page));
    
    result.fold(
      (failure) => emit(MoviesError(message: failure.message)),
      (tvShows) => emit(TvShowsLoaded(
        tvShows: tvShows,
        hasReachedMax: tvShows.length < 20,
        currentPage: event.page,
      )),
    );
  }
  
  Future<void> _onDiscoverTvShows(
    DiscoverTvShowsEvent event,
    Emitter<MoviesState> emit,
  ) async {
    // If page is 1, reset the list. Otherwise, append to existing list
    if (event.page == 1) {
      emit(MoviesLoading());
    }
    
    final result = await discoverTvShows(DiscoverTvShowsParams(
      genreId: event.genreId,
      year: event.year,
      minRating: event.minRating,
      page: event.page,
    ));
    
    result.fold(
      (failure) => emit(MoviesError(message: failure.message)),
      (tvShows) {
        if (event.page == 1) {
          // First page - replace the list
          emit(TvShowsLoaded(
            tvShows: tvShows,
            hasReachedMax: tvShows.length < 20,
            currentPage: event.page,
          ));
        } else {
          // Subsequent pages - append to existing list
          if (state is TvShowsLoaded) {
            final currentState = state as TvShowsLoaded;
            final allTvShows = [...currentState.tvShows, ...tvShows];
            emit(TvShowsLoaded(
              tvShows: allTvShows,
              hasReachedMax: tvShows.length < 20,
              currentPage: event.page,
            ));
          } else {
            emit(TvShowsLoaded(
              tvShows: tvShows,
              hasReachedMax: tvShows.length < 20,
              currentPage: event.page,
            ));
          }
        }
      },
    );
  }
  
  Future<void> _onGetTvShowDetails(
    GetTvShowDetailsEvent event,
    Emitter<MoviesState> emit,
  ) async {
    emit(TvShowDetailsLoading());
    
    final result = await getTvShowDetails(GetTvShowDetailsParams(tvId: event.tvId));
    
    result.fold(
      (failure) => emit(TvShowDetailsError(message: failure.message)),
      (tvShow) => emit(TvShowDetailsLoaded(tvShow: tvShow)),
    );
  }
  
  Future<void> _onGetTvShowVideos(
    GetTvShowVideosEvent event,
    Emitter<MoviesState> emit,
  ) async {
    emit(VideosLoading());
    
    final result = await getTvShowVideos(GetTvShowVideosParams(tvId: event.tvId));
    
    result.fold(
      (failure) => emit(VideosError(message: failure.message)),
      (videos) => emit(VideosLoaded(videos: videos)),
    );
  }
}
