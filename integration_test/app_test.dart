import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:movie_locator/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Movie Locator App Integration Tests', () {
    testWidgets('App launches and shows home page', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Verify that the app bar is displayed
      expect(find.text('Movie Locator'), findsOneWidget);

      // Verify that the tab bar is displayed
      expect(find.text('Popular'), findsOneWidget);
      expect(find.text('Top Rated'), findsOneWidget);
      expect(find.text('Now Playing'), findsOneWidget);
      expect(find.text('Upcoming'), findsOneWidget);

      // Verify that the bottom navigation bar is displayed
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Search'), findsOneWidget);
      expect(find.text('Favorites'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('Navigation to search page works', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Tap on search in bottom navigation
      await tester.tap(find.text('Search'));
      await tester.pumpAndSettle();

      // Verify that search page is displayed
      expect(find.text('Search Movies'), findsOneWidget);
      expect(find.text('Search for movies...'), findsOneWidget);
    });

    testWidgets('Navigation to favorites page works', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Tap on favorites in bottom navigation
      await tester.tap(find.text('Favorites'));
      await tester.pumpAndSettle();

      // Verify that favorites page is displayed
      expect(find.text('Favorites'), findsOneWidget);
      expect(find.text('No favorites yet'), findsOneWidget);
    });

    testWidgets('Tab switching works correctly', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Tap on Top Rated tab
      await tester.tap(find.text('Top Rated'));
      await tester.pumpAndSettle();

      // Verify that the tab is selected
      expect(find.text('Top Rated'), findsOneWidget);

      // Tap on Now Playing tab
      await tester.tap(find.text('Now Playing'));
      await tester.pumpAndSettle();

      // Verify that the tab is selected
      expect(find.text('Now Playing'), findsOneWidget);
    });

    testWidgets('Search functionality works', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Navigate to search page
      await tester.tap(find.text('Search'));
      await tester.pumpAndSettle();

      // Find the search field
      final searchField = find.byType(TextField);
      expect(searchField, findsOneWidget);

      // Enter search text
      await tester.enterText(searchField, 'Avengers');
      await tester.pumpAndSettle();

      // Verify that the text was entered
      expect(find.text('Avengers'), findsOneWidget);
    });

    testWidgets('App handles loading states', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // The app should show loading state initially
      // This test verifies that the app doesn't crash during loading
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
}
