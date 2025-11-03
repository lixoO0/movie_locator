import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../network/api_client.dart';
import '../network/network_info.dart';
import '../database/app_database.dart';
import '../../features/movies/data/datasources/movies_remote_datasource.dart';
import '../../features/movies/data/datasources/movies_local_datasource.dart';
import '../../features/movies/data/repositories/movies_repository_impl.dart';
import '../../features/movies/domain/repositories/movies_repository.dart';
import '../../features/movies/domain/usecases/get_popular_movies.dart';
import '../../features/movies/domain/usecases/get_top_rated_movies.dart';
import '../../features/movies/domain/usecases/get_movie_details.dart';
import '../../features/movies/domain/usecases/search_movies.dart';
import '../../features/movies/domain/usecases/get_movie_genres.dart';
import '../../features/movies/presentation/bloc/movies_bloc.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_user.dart';
import '../../features/auth/domain/usecases/register_user.dart';
import '../../features/auth/domain/usecases/logout_user.dart';
import '../../features/auth/domain/usecases/get_current_user.dart';
import '../../features/auth/domain/usecases/check_authentication.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/favorites/data/repositories/favorites_repository_impl.dart';
import '../../features/favorites/domain/repositories/favorites_repository.dart';
import '../../features/favorites/domain/usecases/get_favorites.dart';
import '../../features/favorites/domain/usecases/add_favorite.dart';
import '../../features/favorites/domain/usecases/remove_favorite.dart';
import '../../features/favorites/domain/usecases/check_is_favorite.dart';
import '../../features/favorites/presentation/bloc/favorites_bloc.dart';

// part 'injection.config.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Initialize Hive
  await Hive.initFlutter();
  
  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);
  
  // Initialize SecureStorage
  getIt.registerSingleton<FlutterSecureStorage>(const FlutterSecureStorage());
  
  // Initialize Connectivity
  getIt.registerSingleton<Connectivity>(Connectivity());
  
  // Initialize NetworkInfo
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(getIt<Connectivity>()),
  );
  
  // Initialize Dio
  getIt.registerLazySingleton<Dio>(() => Dio());
  
  // Initialize ApiClient
  getIt.registerLazySingleton<ApiClient>(() => ApiClient.create());
  
  // Initialize Database
  getIt.registerLazySingleton<AppDatabase>(() => AppDatabase());
  
  // Initialize Data Sources
  getIt.registerLazySingleton<MoviesRemoteDataSource>(
    () => MoviesRemoteDataSourceImpl(apiClient: getIt<ApiClient>()),
  );
  
  getIt.registerLazySingleton<MoviesLocalDataSource>(
    () => MoviesLocalDataSourceImpl(database: getIt<AppDatabase>()),
  );
  
  // Initialize Repositories
  getIt.registerLazySingleton<MoviesRepository>(
    () => MoviesRepositoryImpl(
      remoteDataSource: getIt<MoviesRemoteDataSource>(),
      localDataSource: getIt<MoviesLocalDataSource>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );
  
  // Initialize Use Cases
  getIt.registerLazySingleton(() => GetPopularMovies(getIt<MoviesRepository>()));
  getIt.registerLazySingleton(() => GetTopRatedMovies(getIt<MoviesRepository>()));
  getIt.registerLazySingleton(() => GetMovieDetails(getIt<MoviesRepository>()));
  getIt.registerLazySingleton(() => SearchMovies(getIt<MoviesRepository>()));
  getIt.registerLazySingleton(() => GetMovieGenres(getIt<MoviesRepository>()));
  
  // Initialize Auth Data Sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: getIt<Dio>()),
  );
  
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(secureStorage: getIt<FlutterSecureStorage>()),
  );
  
  // Initialize Auth Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
      localDataSource: getIt<AuthLocalDataSource>(),
    ),
  );
  
  // Initialize Auth Use Cases
  getIt.registerLazySingleton(() => LoginUser(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => RegisterUser(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => LogoutUser(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => GetCurrentUser(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => CheckAuthentication(getIt<AuthRepository>()));
  
  // Initialize BLoCs
  getIt.registerFactory(
    () => MoviesBloc(
      getPopularMovies: getIt<GetPopularMovies>(),
      getTopRatedMovies: getIt<GetTopRatedMovies>(),
      getMovieDetails: getIt<GetMovieDetails>(),
      searchMovies: getIt<SearchMovies>(),
      getMovieGenres: getIt<GetMovieGenres>(),
    ),
  );
  
  getIt.registerFactory(
    () => AuthBloc(
      loginUser: getIt<LoginUser>(),
      registerUser: getIt<RegisterUser>(),
      logoutUser: getIt<LogoutUser>(),
      getCurrentUser: getIt<GetCurrentUser>(),
      checkAuthentication: getIt<CheckAuthentication>(),
    ),
  );
  
  // Initialize Favorites Repository
  getIt.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(database: getIt<AppDatabase>()),
  );
  
  // Initialize Favorites Use Cases
  getIt.registerLazySingleton(() => GetFavorites(getIt<FavoritesRepository>()));
  getIt.registerLazySingleton(() => AddFavorite(getIt<FavoritesRepository>()));
  getIt.registerLazySingleton(() => RemoveFavorite(getIt<FavoritesRepository>()));
  getIt.registerLazySingleton(() => CheckIsFavorite(getIt<FavoritesRepository>()));
  
  // Initialize Favorites BLoC
  getIt.registerFactory(
    () => FavoritesBloc(
      getFavorites: getIt<GetFavorites>(),
      addFavorite: getIt<AddFavorite>(),
      removeFavorite: getIt<RemoveFavorite>(),
      checkIsFavorite: getIt<CheckIsFavorite>(),
    ),
  );
}
