import 'package:dio/dio.dart';

/// Custom retry interceptor for Dio HTTP client
/// Implements exponential backoff retry strategy
class RetryInterceptor extends Interceptor {
  final int maxRetries;
  final Duration retryDelay;
  final Duration maxDelay;
  
  RetryInterceptor({
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
    this.maxDelay = const Duration(seconds: 30),
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final retryCount = err.requestOptions.extra['retryCount'] as int? ?? 0;
    
    // Check if we should retry
    if (retryCount < maxRetries && _shouldRetry(err)) {
      // Increment retry count
      err.requestOptions.extra['retryCount'] = retryCount + 1;
      
      // Calculate delay with exponential backoff
      final delay = Duration(
        milliseconds: (retryDelay.inMilliseconds * (1 << retryCount))
            .clamp(0, maxDelay.inMilliseconds),
      );
      
      await Future.delayed(delay);
      
      try {
        // Retry the request using the same Dio instance
        // Create a new Dio instance with the same base configuration
        final dio = Dio(BaseOptions(
          baseUrl: err.requestOptions.baseUrl,
          connectTimeout: err.requestOptions.connectTimeout,
          receiveTimeout: err.requestOptions.receiveTimeout,
          sendTimeout: err.requestOptions.sendTimeout,
          headers: err.requestOptions.headers,
          queryParameters: err.requestOptions.queryParameters,
        ));
        
        final response = await dio.fetch(err.requestOptions);
        handler.resolve(response);
      } catch (e) {
        if (e is DioException) {
          super.onError(e, handler);
        } else {
          super.onError(err, handler);
        }
      }
    } else {
      super.onError(err, handler);
    }
  }

  /// Determines if a request should be retried based on the error
  bool _shouldRetry(DioException error) {
    // Retry on network errors
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError) {
      return true;
    }
    
    // Retry on 5xx server errors
    if (error.response != null) {
      final statusCode = error.response!.statusCode;
      if (statusCode != null && statusCode >= 500 && statusCode < 600) {
        return true;
      }
    }
    
    return false;
  }
}

