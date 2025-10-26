import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../network/api_client.dart';
import '../network/network_info.dart';
import '../../features/movies/data/datasources/movies_remote_datasource.dart';
import '../../features/movies/data/repositories/movies_repository_impl.dart';
import '../../features/movies/domain/repositories/movies_repository.dart';
import '../../features/movies/domain/usecases/get_popular_movies.dart';
import '../../features/movies/domain/usecases/get_top_rated_movies.dart';
import '../../features/movies/domain/usecases/get_movie_details.dart';
import '../../features/movies/domain/usecases/search_movies.dart';
import '../../features/movies/domain/usecases/get_movie_genres.dart';
import '../../features/movies/presentation/bloc/movies_bloc.dart';

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
  
  // Initialize Data Sources
  getIt.registerLazySingleton<MoviesRemoteDataSource>(
    () => MoviesRemoteDataSourceImpl(apiClient: getIt<ApiClient>()),
  );
  
  // Initialize Repositories
  getIt.registerLazySingleton<MoviesRepository>(
    () => MoviesRepositoryImpl(
      remoteDataSource: getIt<MoviesRemoteDataSource>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );
  
  // Initialize Use Cases
  getIt.registerLazySingleton(() => GetPopularMovies(getIt<MoviesRepository>()));
  getIt.registerLazySingleton(() => GetTopRatedMovies(getIt<MoviesRepository>()));
  getIt.registerLazySingleton(() => GetMovieDetails(getIt<MoviesRepository>()));
  getIt.registerLazySingleton(() => SearchMovies(getIt<MoviesRepository>()));
  getIt.registerLazySingleton(() => GetMovieGenres(getIt<MoviesRepository>()));
  
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
}
