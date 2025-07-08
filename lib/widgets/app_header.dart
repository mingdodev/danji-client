import 'package:danji_client/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppHeader extends StatelessWidget {
  final String blueTitle, blackTitle;

  const AppHeader({
    super.key,
    required this.blueTitle,
    required this.blackTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFD9D9D9))),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () => context.pop(),
            ),
          ),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                fontFamily: 'Pretendard',
                letterSpacing: 0.72,
              ),
              children: [
                TextSpan(
                  text: blueTitle,
                  style: const TextStyle(color: AppColors.primary),
                ),
                TextSpan(
                  text: blackTitle,
                  style: const TextStyle(color: AppColors.grayDark),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
