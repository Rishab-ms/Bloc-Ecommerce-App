import 'package:dio/dio.dart';

/// A lightweight wrapper for configuring and using Dio.
///
/// If you're used to the `http` package, think of this as the place where
/// you normally create your `http.Client()`.  
///
/// Instead of creating a new Dio instance everywhere, this class:
/// - sets up a single, reusable client
/// - configures common settings (base URL, timeouts)
/// - adds logging so you can see what requests/responses look like
///
/// This keeps your API code cleaner and avoids repeating the same setup.
class DioClient {
  final Dio _dio;

  DioClient()
      : _dio = Dio(
          BaseOptions(
            // Similar to prefixing all `http` requests with a base URL manually.
            baseUrl: 'https://dummyjson.com',

            // Equivalent to setting a timeout on every `http` request,
            // but handled centrally instead of per-request.
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),

            // Automatically treats responses as JSON instead of raw text.
            responseType: ResponseType.json,
          ),
        ) {
    // Adds a logging interceptor.
    //
    // If you're coming from the `http` package, you're probably used to doing:
    //   print(response.body);
    //
    // Dio can log the request and response for you automatically,
    // which makes debugging API calls easier.
    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      responseBody: true,
      responseHeader: false,
      error: true,
    ));
  }

  /// Exposes the configured Dio instance so the rest of the app can use it.
  ///
  /// Example:
  /// ```dart
  /// final dio = DioClient().api;
  /// final response = await dio.get('/products');
  /// ```
  Dio get api => _dio;
}
