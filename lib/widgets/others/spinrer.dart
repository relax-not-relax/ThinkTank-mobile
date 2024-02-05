import 'package:flutter/material.dart';

class CustomLoadingSpinner extends StatelessWidget {
  const CustomLoadingSpinner({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 60.0,
      height: 60.0,
      child: CircularProgressIndicator(
        strokeWidth: 7.0, // Độ dày của vòng tròn
        valueColor: AlwaysStoppedAnimation<Color>(
            Color.fromARGB(255, 245, 149, 24)), // Màu sắc
      ),
    );
  }
}
