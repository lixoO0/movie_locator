import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../constants/app_constants.dart';

part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;
  
  static ApiClient create() {
    final dio = Dio();
    
    // Add interceptors
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add API key to all requests
          options.queryParameters['api_key'] = dotenv.env[AppConstants.tmdbApiKey];
          options.queryParameters['language'] = 'en-US';
          handler.next(options);
        },
        onError: (error, handler) {
          // Handle common errors
          if (error.response?.statusCode == 401) {
            // Handle unauthorized
          } else if (error.response?.statusCode == 404) {
            // Handle not found
          } else if (error.response?.statusCode == 500) {
            // Handle server error
          }
          handler.next(error);
        },
      ),
    );
    
    // Add logging interceptor in debug mode
    if (const bool.fromEnvironment('dart.vm.product') == false) {
      dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (object) => print(object),
      ));
    }
    
    return ApiClient(dio, baseUrl: AppConstants.tmdbBaseUrl);
  }
  
  // Movies endpoints
  @GET('/movie/popular')
  Future<Map<String, dynamic>> getPopularMovies({
    @Query('page') int page = 1,
  });
  
  @GET('/movie/top_rated')
  Future<Map<String, dynamic>> getTopRatedMovies({
    @Query('page') int page = 1,
  });
  
  @GET('/movie/now_playing')
  Future<Map<String, dynamic>> getNowPlayingMovies({
    @Query('page') int page = 1,
  });
  
  @GET('/movie/upcoming')
  Future<Map<String, dynamic>> getUpcomingMovies({
    @Query('page') int page = 1,
  });
  
  @GET('/movie/{movie_id}')
  Future<Map<String, dynamic>> getMovieDetails(
    @Path('movie_id') int movieId,
  );
  
  @GET('/movie/{movie_id}/credits')
  Future<Map<String, dynamic>> getMovieCredits(
    @Path('movie_id') int movieId,
  );
  
  @GET('/movie/{movie_id}/videos')
  Future<Map<String, dynamic>> getMovieVideos(
    @Path('movie_id') int movieId,
  );
  
  @GET('/movie/{movie_id}/reviews')
  Future<Map<String, dynamic>> getMovieReviews(
    @Path('movie_id') int movieId, {
    @Query('page') int page = 1,
  });
  
  // TV Shows endpoints
  @GET('/tv/popular')
  Future<Map<String, dynamic>> getPopularTvShows({
    @Query('page') int page = 1,
  });
  
  @GET('/tv/top_rated')
  Future<Map<String, dynamic>> getTopRatedTvShows({
    @Query('page') int page = 1,
  });
  
  @GET('/tv/on_the_air')
  Future<Map<String, dynamic>> getOnTheAirTvShows({
    @Query('page') int page = 1,
  });
  
  @GET('/tv/{tv_id}')
  Future<Map<String, dynamic>> getTvShowDetails(
    @Path('tv_id') int tvId,
  );
  
  // Search endpoints
  @GET('/search/movie')
  Future<Map<String, dynamic>> searchMovies({
    @Query('query') required String query,
    @Query('page') int page = 1,
  });
  
  @GET('/search/tv')
  Future<Map<String, dynamic>> searchTvShows({
    @Query('query') required String query,
    @Query('page') int page = 1,
  });
  
  @GET('/search/multi')
  Future<Map<String, dynamic>> searchMulti({
    @Query('query') required String query,
    @Query('page') int page = 1,
  });
  
  // Genres endpoints
  @GET('/genre/movie/list')
  Future<Map<String, dynamic>> getMovieGenres();
  
  @GET('/genre/tv/list')
  Future<Map<String, dynamic>> getTvGenres();
}
