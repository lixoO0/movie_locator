class AppConstants {
  // API Configuration
  static const String tmdbBaseUrl = 'https://api.themoviedb.org/3';
  static const String tmdbImageBaseUrl = 'https://image.tmdb.org/t/p';
  static const String tmdbApiKey = 'TMDB_API_KEY';
  
  // Image Sizes
  static const String imageSizeSmall = 'w185';
  static const String imageSizeMedium = 'w342';
  static const String imageSizeLarge = 'w500';
  static const String imageSizeOriginal = 'original';
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 1000;
  
  // Cache Duration
  static const int cacheDurationHours = 24;
  static const int cacheDurationMinutes = 60;
  
  // Database
  static const String databaseName = 'movie_locator.db';
  static const int databaseVersion = 1;
  
  // Storage Keys
  static const String favoritesBoxName = 'favorites';
  static const String settingsBoxName = 'settings';
  static const String userBoxName = 'user';
  
  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double cardElevation = 4.0;
  
  // Error Messages
  static const String networkErrorMessage = 'Network connection error';
  static const String serverErrorMessage = 'Server error occurred';
  static const String unknownErrorMessage = 'Unknown error occurred';
  static const String noDataMessage = 'No data available';
  
  // Success Messages
  static const String movieAddedToFavorites = 'Movie added to favorites';
  static const String movieRemovedFromFavorites = 'Movie removed from favorites';
}
