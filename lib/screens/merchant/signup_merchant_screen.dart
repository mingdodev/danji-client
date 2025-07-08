import 'dart:io';

import 'package:danji_client/constants/colors.dart';
import 'package:danji_client/services/auth_service.dart';
import 'package:danji_client/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';

class SignupMerchantScreen extends StatefulWidget {
  const SignupMerchantScreen({super.key});

  @override
  State<SignupMerchantScreen> createState() => _SignupMerchantScreenState();
}

class _SignupMerchantScreenState extends State<SignupMerchantScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _marketController = TextEditingController();
  final _addressController = TextEditingController();

  File? _profileImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _profileImage = File(picked.path);
      });
    }
  }

  void _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();
    final market =  _marketController.text.trim();
    final address = _addressController.text.trim();
    final image = _profileImage;

    try {
      await AuthService().signupMerchant(
        email: email,
        password: password,
        name: name,
        marketName: market,
        marketAddress: address,
        image: image,
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
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _marketController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Stack(
            children: [
              ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  const SizedBox(height: 80),
                  const Center(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '사장님 ',
                            style: TextStyle(
                              color: Color(0xFF1E88E5),
                              fontSize: 36,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          TextSpan(
                            text: '회원가입',
                            style: TextStyle(
                              color: Color(0xFF424242),
                              fontSize: 36,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                  const Text('이메일 아이디 *'),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),
                  const Text('비밀번호 *'),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),
                  const Text('사장님 이름 *'),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),
                  const Text('상호명 *'),
                  TextFormField(
                    controller: _marketController,
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),
                  const Text('주소 *'),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 24),
                    GestureDetector(
                      onTap: _pickImage,
                      child: _profileImage == null
                          ? Container(
                              width: 346,
                              height: 57,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF4F4F4), // 밝은 회색 배경
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.upload, color: Color(0xFF79747E)),
                                  SizedBox(width: 8),
                                  Text(
                                    'upload image',
                                    style: TextStyle(
                                      color: Color(0xFF79747E),
                                      fontSize: 16,
                                      letterSpacing: 0.54,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              width: 346,
                              height: 57,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF4F4F4), // 밝은 회색 배경
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.upload, color: Color(0xFF79747E)),
                                  SizedBox(width: 8),
                                  Text(
                                    'image selected',
                                    style: TextStyle(
                                      color: Color(0xFF79747E),
                                      fontSize: 16,
                                      letterSpacing: 0.54,
                                    ),
                                  ),
                                ],
                              ),
                            )
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
            ],
          ),
        ),
      ),
    );
  }
}
