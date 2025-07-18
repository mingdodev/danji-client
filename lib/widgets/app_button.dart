import 'package:flutter/material.dart';
import 'package:danji_client/constants/colors.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color textColor;
  final Color backgroundColor;
  final double fontSize;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.textColor = const Color.fromARGB(255, 255, 255, 255),
    this.backgroundColor = AppColors.primary,
    this.fontSize = 19,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 346,
      height: 57,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 0,
          side: BorderSide(color: textColor, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w500,
            letterSpacing: 0.76,
          ),
        ),
      ),
    );
  }
}