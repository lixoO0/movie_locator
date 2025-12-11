# 🎬 Movie Locator

A comprehensive Flutter application for discovering and exploring movies and TV shows using The Movie Database (TMDB) API. Built with Clean Architecture and modern Flutter best practices.

## 📱 Features

### ✅ Implemented Features

#### 🎥 Movies & TV Shows
- **Movie Discovery**: Browse popular, top-rated, now playing, and upcoming movies
- **TV Shows Discovery**: Browse popular and top-rated TV shows
- **Separate Catalogs**: Dedicated catalog pages for movies and TV shows
- **Movie Details**: Detailed view with ratings, overview, cast, and metadata
- **TV Show Details**: Detailed information about TV series
- **Trailer Playback**: Watch movie and TV show trailers via YouTube integration

#### 🔍 Search & Filtering
- **Advanced Search**: Search for movies and TV shows by title
- **Genre Filtering**: Filter movies and TV shows by genre
- **Year Filtering**: Filter content by release year
- **Rating Filtering**: Filter by minimum rating
- **Combined Filters**: Apply multiple filters simultaneously

#### 👤 User Authentication
- **User Registration**: Create account with email and password
- **User Login**: Secure authentication system
- **Password Security**: SHA-256 password hashing
- **Local Database**: User data stored securely in Drift database
- **Session Management**: Persistent authentication state

#### ⭐ Favorites System
- **Add to Favorites**: Save your favorite movies
- **Remove from Favorites**: Manage your favorites list
- **Protected Access**: Favorites only available for authenticated users
- **Local Storage**: Favorites stored in local database

#### 🎨 UI/UX
- **Modern Design**: Material Design 3 with beautiful UI
- **Theme Toggle**: Switch between light and dark themes
- **Responsive Layout**: Optimized for different screen sizes
- **Loading States**: Shimmer loading animations
- **Error Handling**: Comprehensive error states with retry mechanisms
- **Image Caching**: Optimized image loading with cached_network_image
- **Smooth Navigation**: Seamless navigation between screens

#### 🔧 Technical Features
- **Offline Support**: Local caching with Drift database
- **Network Retry**: Automatic retry mechanism for failed requests
- **Error Recovery**: Graceful error handling and user feedback
- **Performance Optimized**: Lazy loading and efficient state management

## 🏗️ Architecture

The project follows **Clean Architecture** principles with clear separation of concerns:

- **Presentation Layer**: UI components, BLoC state management, and widgets
- **Domain Layer**: Business logic, entities, use cases, and repository interfaces
- **Data Layer**: Data sources (remote and local), models, and repository implementations

### Design Patterns
- **BLoC Pattern**: State management with Events and States
- **Repository Pattern**: Data abstraction layer
- **Dependency Injection**: GetIt for managing dependencies
- **Use Cases**: Single responsibility business logic units

## 🛠️ Tech Stack

### Core
- **Flutter** 3.7.2+ - UI framework
- **Dart** - Programming language

### State Management
- **flutter_bloc** ^8.1.6 - BLoC pattern implementation
- **equatable** ^2.0.5 - Value equality

### Networking
- **dio** ^5.4.3+1 - HTTP client
- **retrofit** ^4.1.0 - API code generation
- **json_annotation** ^4.8.1 - JSON serialization

### Local Storage
- **drift** ^2.18.0 - Reactive database (SQLite)
- **hive** ^2.2.3 - Key-value storage
- **shared_preferences** ^2.2.3 - Simple key-value storage
- **flutter_secure_storage** ^9.2.2 - Secure storage

### Dependency Injection
- **get_it** ^7.6.7 - Service locator
- **injectable** ^2.4.1 - Code generation for DI

### Navigation
- **go_router** ^14.2.7 - Declarative routing

### UI Components
- **cached_network_image** ^3.3.1 - Image caching
- **shimmer** ^3.0.0 - Loading animations
- **lottie** ^3.1.2 - Animations
- **flutter_svg** ^2.0.10+1 - SVG support

### Utilities
- **dartz** ^0.10.1 - Functional programming
- **connectivity_plus** ^6.0.5 - Network connectivity
- **url_launcher** ^6.2.5 - Launch URLs (trailers)
- **crypto** ^3.0.6 - Password hashing
- **intl** ^0.19.0 - Internationalization
- **flutter_dotenv** ^5.1.0 - Environment variables

## 📂 Project Structure

```
lib/
├── core/                           # Core utilities and configurations
│   ├── constants/                  # App constants
│   │   └── app_constants.dart
│   ├── database/                   # Database setup
│   │   ├── app_database.dart       # Drift database schema
│   │   └── app_database.g.dart     # Generated database code
│   ├── di/                         # Dependency injection
│   │   └── injection.dart          # GetIt configuration
│   ├── errors/                     # Error handling
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── network/                    # Network configuration
│   │   ├── api_client.dart         # TMDB API client
│   │   ├── network_info.dart       # Connectivity checker
│   │   └── retry_interceptor.dart  # Retry mechanism
│   ├── usecases/                   # Base use case classes
│   │   └── usecase.dart
│   └── utils/                      # Utility functions
│
├── features/                       # Feature modules
│   ├── auth/                       # Authentication feature
│   │   ├── data/
│   │   │   ├── datasources/        # Auth data sources
│   │   │   ├── models/             # User model
│   │   │   └── repositories/       # Auth repository implementation
│   │   ├── domain/
│   │   │   ├── entities/           # User entity
│   │   │   ├── repositories/        # Auth repository interface
│   │   │   └── usecases/           # Auth use cases
│   │   └── presentation/
│   │       ├── bloc/               # Auth BLoC
│   │       ├── pages/              # Login, Register, Profile pages
│   │       └── widgets/            # Auth widgets
│   │
│   ├── movies/                     # Movies & TV Shows feature
│   │   ├── data/
│   │   │   ├── datasources/        # Remote & local data sources
│   │   │   ├── models/             # Movie, TV Show, Video models
│   │   │   └── repositories/       # Movies repository implementation
│   │   ├── domain/
│   │   │   ├── entities/           # Movie, TV Show, Video entities
│   │   │   ├── repositories/       # Movies repository interface
│   │   │   └── usecases/           # Movies & TV shows use cases
│   │   └── presentation/
│   │       ├── bloc/               # Movies BLoC
│   │       ├── pages/              # Home, Details, Catalog pages
│   │       └── widgets/            # Movie/TV show cards, lists
│   │
│   ├── search/                     # Search feature
│   │   └── presentation/
│   │       └── pages/              # Search page with filters
│   │
│   └── favorites/                  # Favorites feature
│       ├── data/
│       ├── domain/
│       │   ├── entities/           # Favorite movie entity
│       │   ├── repositories/       # Favorites repository
│       │   └── usecases/           # Favorites use cases
│       └── presentation/
│           ├── bloc/               # Favorites BLoC
│           └── pages/              # Favorites page
│
├── shared/                         # Shared components
│   ├── theme/                      # App theming
│   │   ├── app_theme.dart          # Theme configuration
│   │   └── theme_bloc.dart         # Theme state management
│   ├── widgets/                    # Reusable widgets
│   │   └── main_scaffold.dart      # Main app scaffold
│   └── utils/                      # Shared utilities
│
└── main.dart                       # App entry point
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.7.2 or higher
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- TMDB API Key ([Get one here](https://www.themoviedb.org/settings/api))

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/lixoO0/movie_locator.git
   cd movie_locator
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Setup environment variables**
   - Create a `.env` file in the root directory
   - Add your TMDB API key:
     ```
     TMDB_API_KEY=your_tmdb_api_key_here
     ```

4. **Generate code**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
   
   This will generate:
   - Drift database code (`app_database.g.dart`)
   - JSON serialization code
   - Retrofit API client code
   - Mockito mocks (for testing)

5. **Run the app**
   ```bash
   flutter run
   ```

### Getting TMDB API Key

1. Visit [TMDB API Settings](https://www.themoviedb.org/settings/api)
2. Create an account (if you don't have one)
3. Request an API key
4. Copy the API key and add it to your `.env` file

## 📱 App Routes

- `/` - Home page with movie categories
- `/movies` - Movies catalog with filtering
- `/tv-shows` - TV shows catalog with filtering
- `/movie/:id` - Movie details page
- `/tv-show/:id` - TV show details page
- `/search` - Search page with filters
- `/favorites` - Favorites page (requires authentication)
- `/profile` - User profile page (requires authentication)
- `/login` - Login page
- `/register` - Registration page

## 🧪 Testing

The project includes comprehensive testing:

- **Unit Tests**: Business logic and use cases
- **BLoC Tests**: State management testing
- **Widget Tests**: UI components testing
- **Integration Tests**: End-to-end user flows

Run tests:
```bash
flutter test
```

## 🔒 Security

- **API Keys**: Stored in environment variables (`.env`)
- **Password Hashing**: SHA-256 hashing for user passwords
- **Secure Storage**: Sensitive data stored using `flutter_secure_storage`
- **Input Validation**: Form validation on login/registration

## 📊 Performance Optimizations

- **Lazy Loading**: Infinite scroll for movie/TV show lists
- **Image Caching**: Efficient image loading and caching
- **Widget Rebuild Optimization**: BLoC prevents unnecessary rebuilds
- **Memory Management**: Proper disposal of resources
- **Network Optimization**: Retry interceptors and connection checking
- **Offline-first**: Local database caching for better UX

## 🌐 API Integration

- **The Movie Database (TMDB) API**: Primary data source
- **Dio HTTP Client**: With interceptors for logging and retry
- **Error Handling**: Custom exceptions and failure types
- **Network Connectivity**: Automatic checking before API calls

## 🎨 Theme Support

The app supports both light and dark themes:
- Toggle theme from the app bar
- Theme preference is persisted
- Material Design 3 color scheme

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 👤 Author

**lixoO0**

- GitHub: [@lixoO0](https://github.com/lixoO0)

## 🙏 Acknowledgments

- [The Movie Database (TMDB)](https://www.themoviedb.org/) for providing the API
- Flutter team for the amazing framework
- All open-source contributors whose packages made this project possible

---

Made with ❤️ using Flutter
