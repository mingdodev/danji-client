import 'package:danji_client/constants/colors.dart';
import 'package:danji_client/models/api_error.dart';
import 'package:danji_client/services/auth_service.dart';
import 'package:danji_client/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
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
                controller: emailController,
                decoration: const InputDecoration(labelText: '이메일'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: '비밀번호'),
              ),
              const SizedBox(height: 40),
              AppButton(
                text: '로그인',
                backgroundColor: AppColors.primary,
                textColor: AppColors.background,
                onPressed: () async {
                  final email = emailController.text.trim();
                  final password = passwordController.text.trim();

                  if (context.mounted) {
                    try {
                      final data = await AuthService().login(email, password);

                      ref.read(authProvider.notifier).login(
                        accessToken: data['accessToken'],
                        refreshToken: data['refreshToken'],
                        role: data['role'],
                      );

                      final role = data['role'];
                      if (role == 'CUSTOMER') {
                        context.go('/home/customer');
                      } else {
                        context.go('/home/merchant');
                      }
                    } on ApiError catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.message)),
                      );
                    }
                  }
                },
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
    );
  }
}
