import 'package:dio/dio.dart';
import '../models/user.dart';
import 'api_client.dart';
import 'storage_service.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();
  final TokenStorage _tokenStorage = TokenStorage();
  final UserStorage _userStorage = UserStorage();

  // Helper to parse validation errors
  String _handleDioError(DioException e) {
    if (e.response?.statusCode == 422) {
      final errors = e.response?.data['errors'];
      if (errors is Map) {
        return errors.values.first[0].toString();
      }
      return e.response?.data['message'] ?? "Validation error";
    }
    return e.response?.data['message'] ?? "An unexpected error occurred";
  }

  Future<User> login({
    required String email,
    required String password,
    String deviceName = 'flutter',
  }) async {
    try {
      // 1. Login to get token
      final loginResponse = await _apiClient.dio.post(
        '/api/login',
        data: {'email': email, 'password': password, 'device_name': deviceName},
      );

      final token = loginResponse.data['token'];
      await _tokenStorage.saveToken(token);

      // 2. Fetch user profile
      final user = await fetchMe();
      await _userStorage.saveUser(user);

      return user;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<User> fetchMe() async {
    try {
      final response = await _apiClient.dio.get('/api/user');
      return User.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> logout() async {
    try {
      await _apiClient.dio.post('/api/logout');
    } catch (_) {
      // Ignore logout errors if token is already invalid
    } finally {
      await _tokenStorage.deleteToken();
      await _userStorage.deleteUser();
    }
  }
}
