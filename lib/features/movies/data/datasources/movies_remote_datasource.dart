import 'package:dio/dio.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/movie_model.dart';
import '../models/tv_show_model.dart';
import '../models/genre_model.dart';

abstract class MoviesRemoteDataSource {
  Future<List<MovieModel>> getPopularMovies({int page = 1});
  Future<List<MovieModel>> getTopRatedMovies({int page = 1});
  Future<List<MovieModel>> getNowPlayingMovies({int page = 1});
  Future<List<MovieModel>> getUpcomingMovies({int page = 1});
  Future<MovieModel> getMovieDetails(int movieId);
  Future<List<MovieModel>> searchMovies(String query, {int page = 1});
  
  Future<List<TvShowModel>> getPopularTvShows({int page = 1});
  Future<List<TvShowModel>> getTopRatedTvShows({int page = 1});
  Future<List<TvShowModel>> getOnTheAirTvShows({int page = 1});
  Future<TvShowModel> getTvShowDetails(int tvId);
  Future<List<TvShowModel>> searchTvShows(String query, {int page = 1});
  
  Future<List<GenreModel>> getMovieGenres();
  Future<List<GenreModel>> getTvGenres();
}

class MoviesRemoteDataSourceImpl implements MoviesRemoteDataSource {
  final ApiClient apiClient;
  
  const MoviesRemoteDataSourceImpl({required this.apiClient});
  
  @override
  Future<List<MovieModel>> getPopularMovies({int page = 1}) async {
    try {
      final response = await apiClient.getPopularMovies(page: page);
      final results = response['results'] as List;
      return results.map((json) => MovieModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
  
  @override
  Future<List<MovieModel>> getTopRatedMovies({int page = 1}) async {
    try {
      final response = await apiClient.getTopRatedMovies(page: page);
      final results = response['results'] as List;
      return results.map((json) => MovieModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
  
  @override
  Future<List<MovieModel>> getNowPlayingMovies({int page = 1}) async {
    try {
      final response = await apiClient.getNowPlayingMovies(page: page);
      final results = response['results'] as List;
      return results.map((json) => MovieModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
  
  @override
  Future<List<MovieModel>> getUpcomingMovies({int page = 1}) async {
    try {
      final response = await apiClient.getUpcomingMovies(page: page);
      final results = response['results'] as List;
      return results.map((json) => MovieModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
  
  @override
  Future<MovieModel> getMovieDetails(int movieId) async {
    try {
      final response = await apiClient.getMovieDetails(movieId);
      return MovieModel.fromJson(response);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
  
  @override
  Future<List<MovieModel>> searchMovies(String query, {int page = 1}) async {
    try {
      final response = await apiClient.searchMovies(query: query, page: page);
      final results = response['results'] as List;
      return results.map((json) => MovieModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
  
  @override
  Future<List<TvShowModel>> getPopularTvShows({int page = 1}) async {
    try {
      final response = await apiClient.getPopularTvShows(page: page);
      final results = response['results'] as List;
      return results.map((json) => TvShowModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
  
  @override
  Future<List<TvShowModel>> getTopRatedTvShows({int page = 1}) async {
    try {
      final response = await apiClient.getTopRatedTvShows(page: page);
      final results = response['results'] as List;
      return results.map((json) => TvShowModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
  
  @override
  Future<List<TvShowModel>> getOnTheAirTvShows({int page = 1}) async {
    try {
      final response = await apiClient.getOnTheAirTvShows(page: page);
      final results = response['results'] as List;
      return results.map((json) => TvShowModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
  
  @override
  Future<TvShowModel> getTvShowDetails(int tvId) async {
    try {
      final response = await apiClient.getTvShowDetails(tvId);
      return TvShowModel.fromJson(response);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
  
  @override
  Future<List<TvShowModel>> searchTvShows(String query, {int page = 1}) async {
    try {
      final response = await apiClient.searchTvShows(query: query, page: page);
      final results = response['results'] as List;
      return results.map((json) => TvShowModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
  
  @override
  Future<List<GenreModel>> getMovieGenres() async {
    try {
      final response = await apiClient.getMovieGenres();
      final results = response['genres'] as List;
      return results.map((json) => GenreModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
  
  @override
  Future<List<GenreModel>> getTvGenres() async {
    try {
      final response = await apiClient.getTvGenres();
      final results = response['genres'] as List;
      return results.map((json) => GenreModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
  
  Exception _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(message: 'Connection timeout');
      case DioExceptionType.badResponse:
        return ServerException(message: 'Server error: ${e.response?.statusCode}');
      case DioExceptionType.cancel:
        return NetworkException(message: 'Request cancelled');
      case DioExceptionType.connectionError:
        return NetworkException(message: 'No internet connection');
      default:
        return NetworkException(message: 'Network error occurred');
    }
  }
}
