import 'package:dio/dio.dart';
import '../utils/dio_client.dart';
import '../models/api_error.dart';

class AuthService {
  Future<void> signupCustomer({
    required String email,
    required String password,
    required String name,
  }) async {
    final response = await dio.post(
      '/api/users/signup/customer',
      data: {
        'email': email,
        'password': password,
        'name': name,
      },
    );

    final body = response.data;
    if (body['success'] != true) {
      throw ApiError(message: body['message'] ?? '회원가입에 실패했습니다.');
    }
    print(body);
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/api/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      final body = response.data;

      if (body['success'] == true) {
        return body['data'] ?? {};
      } else {
        throw ApiError.fromMap(body['error']);
      }
    } on DioException catch (e) {
      final message = e.response?.data['error']?['message'] ?? '로그인 중 오류가 발생했습니다.';
      throw ApiError(message: message);
    }
  }
}