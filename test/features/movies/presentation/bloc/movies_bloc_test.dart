import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:movie_locator/features/movies/domain/entities/movie.dart';
import 'package:movie_locator/features/movies/domain/usecases/get_popular_movies.dart';
import 'package:movie_locator/features/movies/domain/usecases/get_top_rated_movies.dart';
import 'package:movie_locator/features/movies/domain/usecases/get_movie_details.dart';
import 'package:movie_locator/features/movies/domain/usecases/search_movies.dart';
import 'package:movie_locator/features/movies/domain/usecases/get_movie_genres.dart';
import 'package:movie_locator/features/movies/domain/usecases/discover_movies.dart';
import 'package:movie_locator/features/movies/domain/usecases/get_movie_videos.dart';
import 'package:movie_locator/features/movies/domain/usecases/get_popular_tv_shows.dart';
import 'package:movie_locator/features/movies/domain/usecases/discover_tv_shows.dart';
import 'package:movie_locator/features/movies/domain/usecases/get_tv_show_details.dart';
import 'package:movie_locator/features/movies/domain/usecases/get_tv_show_videos.dart';
import 'package:movie_locator/features/movies/presentation/bloc/movies_bloc.dart';
import 'package:movie_locator/features/movies/presentation/bloc/movies_event.dart';
import 'package:movie_locator/features/movies/presentation/bloc/movies_state.dart';
import 'package:movie_locator/core/errors/failures.dart';

import 'movies_bloc_test.mocks.dart';

@GenerateMocks([
  GetPopularMovies,
  GetTopRatedMovies,
  GetMovieDetails,
  SearchMovies,
  GetMovieGenres,
  DiscoverMovies,
  GetMovieVideos,
  GetPopularTvShows,
  DiscoverTvShows,
  GetTvShowDetails,
  GetTvShowVideos,
])
void main() {
  late MoviesBloc moviesBloc;
  late MockGetPopularMovies mockGetPopularMovies;
  late MockGetTopRatedMovies mockGetTopRatedMovies;
  late MockGetMovieDetails mockGetMovieDetails;
  late MockSearchMovies mockSearchMovies;
  late MockGetMovieGenres mockGetMovieGenres;
  late MockDiscoverMovies mockDiscoverMovies;
  late MockGetMovieVideos mockGetMovieVideos;
  late MockGetPopularTvShows mockGetPopularTvShows;
  late MockDiscoverTvShows mockDiscoverTvShows;
  late MockGetTvShowDetails mockGetTvShowDetails;
  late MockGetTvShowVideos mockGetTvShowVideos;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    mockGetMovieDetails = MockGetMovieDetails();
    mockSearchMovies = MockSearchMovies();
    mockGetMovieGenres = MockGetMovieGenres();
    mockDiscoverMovies = MockDiscoverMovies();
    mockGetMovieVideos = MockGetMovieVideos();
    mockGetPopularTvShows = MockGetPopularTvShows();
    mockDiscoverTvShows = MockDiscoverTvShows();
    mockGetTvShowDetails = MockGetTvShowDetails();
    mockGetTvShowVideos = MockGetTvShowVideos();

    moviesBloc = MoviesBloc(
      getPopularMovies: mockGetPopularMovies,
      getTopRatedMovies: mockGetTopRatedMovies,
      getMovieDetails: mockGetMovieDetails,
      searchMovies: mockSearchMovies,
      getMovieGenres: mockGetMovieGenres,
      discoverMovies: mockDiscoverMovies,
      getMovieVideos: mockGetMovieVideos,
      getPopularTvShows: mockGetPopularTvShows,
      discoverTvShows: mockDiscoverTvShows,
      getTvShowDetails: mockGetTvShowDetails,
      getTvShowVideos: mockGetTvShowVideos,
    );
  });

  tearDown(() {
    moviesBloc.close();
  });

  const tMovies = [
    Movie(
      id: 1,
      title: 'Test Movie 1',
      overview: 'Test overview 1',
      releaseDate: '2023-01-01',
      voteAverage: 8.5,
      voteCount: 1000,
      genreIds: [1, 2],
      adult: false,
      originalLanguage: 'en',
      originalTitle: 'Test Movie 1',
      popularity: 100.0,
      video: false,
    ),
  ];

  const tMovie = Movie(
    id: 1,
    title: 'Test Movie 1',
    overview: 'Test overview 1',
    releaseDate: '2023-01-01',
    voteAverage: 8.5,
    voteCount: 1000,
    genreIds: [1, 2],
    adult: false,
    originalLanguage: 'en',
    originalTitle: 'Test Movie 1',
    popularity: 100.0,
    video: false,
  );

  group('GetPopularMovies', () {
    test('initial state should be MoviesInitial', () {
      expect(moviesBloc.state, equals(MoviesInitial()));
    });

    blocTest<MoviesBloc, MoviesState>(
      'should emit [MoviesLoading, MoviesLoaded] when successful',
      build: () {
        when(mockGetPopularMovies(any))
            .thenAnswer((_) async => const Right(tMovies));
        return moviesBloc;
      },
      act: (bloc) => bloc.add(const GetPopularMoviesEvent()),
      expect: () => [
        MoviesLoading(),
        const MoviesLoaded(
          movies: tMovies,
          hasReachedMax: true,
          currentPage: 1,
        ),
      ],
      verify: (_) {
        verify(mockGetPopularMovies(const GetPopularMoviesParams(page: 1)));
      },
    );

    blocTest<MoviesBloc, MoviesState>(
      'should emit [MoviesLoading, MoviesError] when failed',
      build: () {
        when(mockGetPopularMovies(any))
            .thenAnswer((_) async => const Left(ServerFailure()));
        return moviesBloc;
      },
      act: (bloc) => bloc.add(const GetPopularMoviesEvent()),
      expect: () => [
        MoviesLoading(),
        const MoviesError(message: 'Server error occurred'),
      ],
      verify: (_) {
        verify(mockGetPopularMovies(const GetPopularMoviesParams(page: 1)));
      },
    );
  });

  group('GetMovieDetails', () {
    blocTest<MoviesBloc, MoviesState>(
      'should emit [MovieDetailsLoading, MovieDetailsLoaded] when successful',
      build: () {
        when(mockGetMovieDetails(any))
            .thenAnswer((_) async => const Right(tMovie));
        return moviesBloc;
      },
      act: (bloc) => bloc.add(const GetMovieDetailsEvent(movieId: 1)),
      expect: () => [
        MovieDetailsLoading(),
        const MovieDetailsLoaded(movie: tMovie),
      ],
      verify: (_) {
        verify(mockGetMovieDetails(const GetMovieDetailsParams(movieId: 1)));
      },
    );

    blocTest<MoviesBloc, MoviesState>(
      'should emit [MovieDetailsLoading, MovieDetailsError] when failed',
      build: () {
        when(mockGetMovieDetails(any))
            .thenAnswer((_) async => const Left(ServerFailure()));
        return moviesBloc;
      },
      act: (bloc) => bloc.add(const GetMovieDetailsEvent(movieId: 1)),
      expect: () => [
        MovieDetailsLoading(),
        const MovieDetailsError(message: 'Server error occurred'),
      ],
      verify: (_) {
        verify(mockGetMovieDetails(const GetMovieDetailsParams(movieId: 1)));
      },
    );
  });
}
