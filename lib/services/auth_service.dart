import 'dart:convert';
import 'dart:io';

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

  Future<void> signupMerchant({
    required String email,
    required String password,
    required String name,
    required String marketName,
    required String marketAddress,
    File? image, // nullable
  }) async {
    final formData = FormData.fromMap({
      'request': MultipartFile.fromString(
        jsonEncode({
          'email': email,
          'password': password,
          'name': name,
          'marketName': marketName,
          'marketAddress': marketAddress,
        }),
        contentType: DioMediaType('application', 'json'),
      ),
      if (image != null)
        'image': await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
          contentType: DioMediaType('image', 'png'),
        ),
    });

    final response = await dio.post(
      '/api/users/signup/merchant',
      data: formData,
    );

    final body = response.data;
    if (body['success'] != true) {
      throw Exception(body['message'] ?? '회원가입에 실패했습니다.');
    }

    print('회원가입 성공: ${body['data']}');
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