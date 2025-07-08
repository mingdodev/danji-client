import 'package:danji_client/constants/colors.dart';
import 'package:danji_client/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:danji_client/widgets/app_button.dart';

class SignupCustomerScreen extends StatefulWidget {
  const SignupCustomerScreen({super.key});

  @override
  State<SignupCustomerScreen> createState() => _SignupCustomerScreenState();
}

class _SignupCustomerScreenState extends State<SignupCustomerScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();

    try {
      await AuthService().signupCustomer(
        email: email,
        password: password,
        name: name,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('회원가입 완료!')),
      );
      context.go('/login');

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('회원가입 실패: ${e.toString()}')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              const SizedBox(height: 80),
              const Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '일반 ',
                        style: TextStyle(
                          color: Color(0xFF1E88E5),
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text: '회원가입',
                        style: TextStyle(
                          color: Color(0xFF424242),
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 60),
              const Text('이메일 아이디 *'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '이메일 입력',
                ),
              ),
              const SizedBox(height: 24),
              const Text('비밀번호 *'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '비밀번호 입력',
                ),
              ),
              const SizedBox(height: 24),
              const Text('이름 *'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '이름 입력',
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 57,
                child: AppButton(
                  onPressed: _submit,
                  textColor: AppColors.background,
                  backgroundColor: AppColors.primary,
                  text: '가입하기',
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
