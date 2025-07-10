import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();
final unauthPaths = [
  '/api/auth/login',
  '/api/users/signup/customer',
  '/api/users/signup/merchant',
];
const prodUrl = 'https://danji.o-r.kr';
const localAPIUrl = 'http://127.0.0.1:8080';

final dio = Dio(
  BaseOptions(
    baseUrl: prodUrl,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
    headers: {
      'Content-Type': 'application/json',
    },
  )
)..interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final requestPath = Uri.parse(options.uri.toString()).path;
        if (!unauthPaths.contains(requestPath)) {
          final token = await storage.read(key: 'accessToken');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
        }
        handler.next(options);
      }
    ),
  );