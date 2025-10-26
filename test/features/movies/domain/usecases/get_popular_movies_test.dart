import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:movie_locator/features/movies/domain/entities/movie.dart';
import 'package:movie_locator/features/movies/domain/repositories/movies_repository.dart';
import 'package:movie_locator/features/movies/domain/usecases/get_popular_movies.dart';
import 'package:movie_locator/core/errors/failures.dart';

import 'get_popular_movies_test.mocks.dart';

@GenerateMocks([MoviesRepository])
void main() {
  late GetPopularMovies usecase;
  late MockMoviesRepository mockMoviesRepository;

  setUp(() {
    mockMoviesRepository = MockMoviesRepository();
    usecase = GetPopularMovies(mockMoviesRepository);
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
    Movie(
      id: 2,
      title: 'Test Movie 2',
      overview: 'Test overview 2',
      releaseDate: '2023-02-01',
      voteAverage: 7.5,
      voteCount: 500,
      genreIds: [3, 4],
      adult: false,
      originalLanguage: 'en',
      originalTitle: 'Test Movie 2',
      popularity: 80.0,
      video: false,
    ),
  ];

  test('should get popular movies from the repository', () async {
    // arrange
    when(mockMoviesRepository.getPopularMovies(page: 1))
        .thenAnswer((_) async => const Right(tMovies));

    // act
    final result = await usecase(const GetPopularMoviesParams(page: 1));

    // assert
    expect(result, const Right(tMovies));
    verify(mockMoviesRepository.getPopularMovies(page: 1));
    verifyNoMoreInteractions(mockMoviesRepository);
  });

  test('should return failure when repository fails', () async {
    // arrange
    when(mockMoviesRepository.getPopularMovies(page: 1))
        .thenAnswer((_) async => const Left(ServerFailure()));

    // act
    final result = await usecase(const GetPopularMoviesParams(page: 1));

    // assert
    expect(result, const Left(ServerFailure()));
    verify(mockMoviesRepository.getPopularMovies(page: 1));
    verifyNoMoreInteractions(mockMoviesRepository);
  });

  test('should use default page when no page is provided', () async {
    // arrange
    when(mockMoviesRepository.getPopularMovies(page: 1))
        .thenAnswer((_) async => const Right(tMovies));

    // act
    final result = await usecase(const GetPopularMoviesParams());

    // assert
    expect(result, const Right(tMovies));
    verify(mockMoviesRepository.getPopularMovies(page: 1));
    verifyNoMoreInteractions(mockMoviesRepository);
  });
}
