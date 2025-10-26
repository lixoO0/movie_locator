import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:movie_locator/features/movies/domain/entities/movie.dart';
import 'package:movie_locator/features/movies/presentation/widgets/movie_card.dart';

void main() {
  const tMovie = Movie(
    id: 1,
    title: 'Test Movie',
    overview: 'Test overview for the movie',
    releaseDate: '2023-01-01',
    voteAverage: 8.5,
    voteCount: 1000,
    genreIds: [1, 2],
    adult: false,
    originalLanguage: 'en',
    originalTitle: 'Test Movie',
    popularity: 100.0,
    video: false,
  );

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: Scaffold(
        body: MovieCard(
          movie: tMovie,
        ),
      ),
    );
  }

  group('MovieCard Widget Tests', () {
    testWidgets('should display movie title', (WidgetTester tester) async {
      // arrange
      await tester.pumpWidget(createWidgetUnderTest());

      // act
      await tester.pumpAndSettle();

      // assert
      expect(find.text('Test Movie'), findsOneWidget);
    });

    testWidgets('should display movie overview', (WidgetTester tester) async {
      // arrange
      await tester.pumpWidget(createWidgetUnderTest());

      // act
      await tester.pumpAndSettle();

      // assert
      expect(find.text('Test overview for the movie'), findsOneWidget);
    });

    testWidgets('should display movie rating', (WidgetTester tester) async {
      // arrange
      await tester.pumpWidget(createWidgetUnderTest());

      // act
      await tester.pumpAndSettle();

      // assert
      expect(find.text('8.5'), findsOneWidget);
    });

    testWidgets('should display release year', (WidgetTester tester) async {
      // arrange
      await tester.pumpWidget(createWidgetUnderTest());

      // act
      await tester.pumpAndSettle();

      // assert
      expect(find.text('2023'), findsOneWidget);
    });

    testWidgets('should call onTap when card is tapped', (WidgetTester tester) async {
      // arrange
      bool onTapCalled = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MovieCard(
              movie: tMovie,
              onTap: () {
                onTapCalled = true;
              },
            ),
          ),
        ),
      );

      // act
      await tester.pumpAndSettle();
      await tester.tap(find.byType(MovieCard));
      await tester.pumpAndSettle();

      // assert
      expect(onTapCalled, isTrue);
    });

    testWidgets('should display favorite icon when onFavoriteTap is provided', (WidgetTester tester) async {
      // arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MovieCard(
              movie: tMovie,
              onFavoriteTap: () {},
            ),
          ),
        ),
      );

      // act
      await tester.pumpAndSettle();

      // assert
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    });

    testWidgets('should display filled favorite icon when isFavorite is true', (WidgetTester tester) async {
      // arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MovieCard(
              movie: tMovie,
              onFavoriteTap: () {},
              isFavorite: true,
            ),
          ),
        ),
      );

      // act
      await tester.pumpAndSettle();

      // assert
      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });
  });
}
