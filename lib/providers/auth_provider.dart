import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthState {
  final bool isLoggedIn;
  final String? accessToken;
  final String? role;

  AuthState({
    required this.isLoggedIn,
    this.accessToken,
    this.role,
  });
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState(isLoggedIn: false));
  
  final storage = FlutterSecureStorage();

  void login({
    required int userId,
    required String accessToken,
    required String refreshToken,
    required String role,
  }) async {
    await storage.write(key: 'userId', value: userId.toString());
    await storage.write(key: 'accessToken', value: accessToken);
    await storage.write(key: 'refreshToken', value: refreshToken);
    await storage.write(key: 'role', value: role);

    state = AuthState(
      isLoggedIn: true,
      accessToken: accessToken,
      role: role,
    );
  }

  void logout() {
    state = AuthState(isLoggedIn: false);
  }
}
