import 'package:dio/dio.dart';
import 'storage_service.dart';

class ApiClient {
  late final Dio dio;
  final TokenStorage _tokenStorage = TokenStorage();

  ApiClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://whisker-cart.onrender.com',
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 13),
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _tokenStorage.readToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            // Clear storage on unauthenticated error
            await _tokenStorage.deleteToken();
            await UserStorage().deleteUser();
          }
          return handler.next(e);
        },
      ),
    );
  }
}
