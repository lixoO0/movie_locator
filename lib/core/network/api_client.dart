import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../constants/app_constants.dart';
import 'retry_interceptor.dart';

class ApiClient {
  final Dio _dio;
  
  ApiClient(this._dio);
  
  static ApiClient create() {
    final dio = Dio(BaseOptions(
      baseUrl: AppConstants.tmdbBaseUrl,
      queryParameters: {
        'api_key': dotenv.env[AppConstants.tmdbApiKey] ?? 'd9958d28016a4e407bca77533fadc6cf',
        'language': 'en-US',
      },
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
    ));
    
    // Add retry interceptor (should be first to catch errors)
    dio.interceptors.add(RetryInterceptor(
      maxRetries: 3,
      retryDelay: const Duration(seconds: 1),
      maxDelay: const Duration(seconds: 10),
    ));
    
    // Add logging interceptor in debug mode
    if (const bool.fromEnvironment('dart.vm.product') == false) {
      dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (object) => print(object),
      ));
    }
    
    return ApiClient(dio);
  }
  
  // Movies endpoints
  Future<Map<String, dynamic>> getPopularMovies({int page = 1}) async {
    final response = await _dio.get('/movie/popular', queryParameters: {'page': page});
    return response.data;
  }
  
  Future<Map<String, dynamic>> getTopRatedMovies({int page = 1}) async {
    final response = await _dio.get('/movie/top_rated', queryParameters: {'page': page});
    return response.data;
  }
  
  Future<Map<String, dynamic>> getNowPlayingMovies({int page = 1}) async {
    final response = await _dio.get('/movie/now_playing', queryParameters: {'page': page});
    return response.data;
  }
  
  Future<Map<String, dynamic>> getUpcomingMovies({int page = 1}) async {
    final response = await _dio.get('/movie/upcoming', queryParameters: {'page': page});
    return response.data;
  }
  
  Future<Map<String, dynamic>> getMovieDetails(int movieId) async {
    final response = await _dio.get('/movie/$movieId');
    return response.data;
  }
  
  // TV Shows endpoints
  Future<Map<String, dynamic>> getPopularTvShows({int page = 1}) async {
    final response = await _dio.get('/tv/popular', queryParameters: {'page': page});
    return response.data;
  }
  
  Future<Map<String, dynamic>> getTopRatedTvShows({int page = 1}) async {
    final response = await _dio.get('/tv/top_rated', queryParameters: {'page': page});
    return response.data;
  }
  
  Future<Map<String, dynamic>> getOnTheAirTvShows({int page = 1}) async {
    final response = await _dio.get('/tv/on_the_air', queryParameters: {'page': page});
    return response.data;
  }
  
  Future<Map<String, dynamic>> getTvShowDetails(int tvId) async {
    final response = await _dio.get('/tv/$tvId');
    return response.data;
  }
  
  // Search endpoints
  Future<Map<String, dynamic>> searchMovies({required String query, int page = 1}) async {
    final response = await _dio.get('/search/movie', queryParameters: {'query': query, 'page': page});
    return response.data;
  }
  
  Future<Map<String, dynamic>> searchTvShows({required String query, int page = 1}) async {
    final response = await _dio.get('/search/tv', queryParameters: {'query': query, 'page': page});
    return response.data;
  }
  
  // Genres endpoints
  Future<Map<String, dynamic>> getMovieGenres() async {
    final response = await _dio.get('/genre/movie/list');
    return response.data;
  }
  
  Future<Map<String, dynamic>> getTvGenres() async {
    final response = await _dio.get('/genre/tv/list');
    return response.data;
  }
}
