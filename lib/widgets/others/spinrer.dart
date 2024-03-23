import 'package:flutter/material.dart';

class CustomLoadingSpinner extends StatelessWidget {
  const CustomLoadingSpinner({
    super.key,
    required this.color,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60.0,
      height: 60.0,
      child: CircularProgressIndicator(
        strokeWidth: 7.0, // Độ dày của vòng tròn
        valueColor: AlwaysStoppedAnimation<Color>(color), // Màu sắc
      ),
    );
  }
}
