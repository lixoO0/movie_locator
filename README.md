# 🎬 Movie Locator

A Flutter movie discovery app that helps you find and explore movies and TV shows using The Movie Database (TMDB) API.

## 🎯 Обрана тема

**Movie Discovery App** - A comprehensive movie and TV show discovery application with modern UI and clean architecture.

## 🏗️ Архітектура

- **Clean Architecture** (3 layers: Presentation, Domain, Data)
- **BLoC Pattern** for state management with Events/States
- **Repository Pattern** for data abstraction
- **Dependency Injection** with GetIt
- **Offline-first** approach with local caching

## 🌐 API Integration

- **The Movie Database (TMDB) API** for movie and TV show data
- **Dio** HTTP client with interceptors
- **Retrofit** for API code generation
- **Error handling** with custom exceptions and failures
- **Network connectivity** checking

## 🚀 Features

### ✅ Implemented Features
- **Movie Discovery**: Browse popular, top-rated, now playing, and upcoming movies
- **Movie Details**: Detailed view with ratings, overview, and metadata
- **Search Functionality**: Search for movies and TV shows
- **Responsive UI**: Modern Material Design 3 with dark/light themes
- **Image Caching**: Optimized image loading with cached_network_image
- **Loading States**: Shimmer loading animations
- **Error Handling**: Comprehensive error states and retry mechanisms

### 🔄 Planned Features
- **Favorites System**: Add/remove movies from favorites
- **Watchlist**: Personal watchlist management
- **Offline Support**: Local storage with Drift database
- **User Authentication**: Firebase Auth integration
- **Push Notifications**: Movie release notifications
- **Trailer Integration**: YouTube trailer playback
- **Reviews & Ratings**: User reviews and ratings

## 🧪 Testing

- **Unit Tests**: Business logic and use cases
- **Widget Tests**: UI components and interactions
- **Integration Tests**: End-to-end user flows
- **Code Coverage**: Target 70%+ coverage

## 📱 Screenshots

*Screenshots will be added after UI implementation*

## 🛠️ Setup Instructions

### Prerequisites
- Flutter SDK (3.7.2 or higher)
- Dart SDK
- Android Studio / VS Code
- TMDB API Key

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/movie_locator.git
   cd movie_locator
   ```

2. **Get dependencies**
   ```bash
   flutter pub get
   ```

3. **Setup environment variables**
   - Copy `.env.example` to `.env`
   - Add your TMDB API key:
     ```
     TMDB_API_KEY=your_tmdb_api_key_here
     ```

4. **Generate code**
   ```bash
   flutter packages pub run build_runner build
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

### Getting TMDB API Key

1. Visit [TMDB API](https://www.themoviedb.org/settings/api)
2. Create an account and request an API key
3. Add the API key to your `.env` file

## 🔧 CI/CD

- **GitHub Actions** for automated testing
- **Automated builds** for Android APK
- **Code coverage** reports
- **Linting** and code quality checks

## 📊 Performance Optimizations

- **Lazy loading** for movie lists
- **Image caching** with cached_network_image
- **Widget rebuild optimization** with BLoC
- **Memory management** with proper disposal
- **Network request optimization** with Dio interceptors

## 🔒 Security Measures

- **API keys** stored in environment variables
- **Secure storage** for sensitive data
- **Code obfuscation** for release builds
- **Input validation** and sanitization

## 🏛️ Project Structure

```
lib/
├── core/                    # Core utilities and configurations
│   ├── constants/          # App constants
│   ├── errors/             # Error handling
│   ├── network/            # Network configuration
│   ├── usecases/           # Base use case classes
│   ├── utils/              # Utility functions
│   └── di/                 # Dependency injection
├── features/               # Feature modules
│   ├── movies/             # Movies feature
│   │   ├── data/           # Data layer
│   │   ├── domain/         # Domain layer
│   │   └── presentation/   # Presentation layer
│   ├── search/             # Search feature
│   └── favorites/          # Favorites feature
├── shared/                 # Shared components
│   ├── widgets/            # Reusable widgets
│   ├── theme/              # App theming
│   └── utils/              # Shared utilities
└── main.dart              # App entry point
```

## 🛠️ Tech Stack

- **Flutter** - UI framework
- **Dart** - Programming language
- **BLoC** - State management
- **GetIt** - Dependency injection
- **Dio** - HTTP client
- **Retrofit** - API code generation
- **Cached Network Image** - Image caching
- **Shimmer** - Loading animations
- **Go Router** - Navigation
- **Hive** - Local storage
- **Drift** - Database

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request
