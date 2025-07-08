import 'package:danji_client/constants/colors.dart';
import 'package:danji_client/models/api_error.dart';
import 'package:danji_client/providers/merchant_provider.dart';
import 'package:danji_client/services/auth_service.dart';
import 'package:danji_client/services/merchant_service.dart';
import 'package:danji_client/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      final data = await AuthService().login(email, password);

      ref.read(authProvider.notifier).login(
        userId: data['userId'],
        accessToken: data['accessToken'],
        refreshToken: data['refreshToken'],
        role: data['role'],
      );

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handlePostLogin(data['role'], data['userId']);
      });
    } on ApiError catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    }
  }

  Future<void> _handlePostLogin(String role, int userId) async {
  if (!mounted) return;

  if (role == 'CUSTOMER') {
    context.go('/home/customer');
  } else if (role == 'MERCHANT') {
    final marketData = await MerchantService().getMarketInfo(userId);
    ref.read(merchantProvider.notifier).update(
      marketName: marketData['marketName'],
      marketId: marketData['marketId'],
      marketAddress: marketData['marketAddress']
    );
    context.go('/home/merchant');
  }
}

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.translucent,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ListView(
              children: [
                const SizedBox(height: 70),
                const Text.rich(
                  TextSpan(
                    style: TextStyle(
                      fontSize: 43,
                      fontFamily: 'SacheonHangong',
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1.29,
                    ),
                    children: [
                      TextSpan(text: '단', style: TextStyle(color: Color(0xFF64B5F6))),
                      TextSpan(text: '체주문\n', style: TextStyle(color: Color(0xFF1E88E5))),
                      TextSpan(text: '지', style: TextStyle(color: Color(0xFF64B5F6))),
                      TextSpan(text: '킴이', style: TextStyle(color: Color(0xFF1E88E5))),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: '이메일'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: '비밀번호'),
                ),
                const SizedBox(height: 40),
                AppButton(
                  text: '로그인',
                  backgroundColor: AppColors.primary,
                  textColor: AppColors.background,
                  onPressed: _login,
                ),
                const SizedBox(height: 10),
                AppButton(
                  text: '일반 회원으로 가입하기',
                  onPressed: () => context.push('/signup/customer'),
                ),
                const SizedBox(height: 10),
                AppButton(
                  text: '사장님으로 가입하기',
                  onPressed: () => context.push('/signup/merchant'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
