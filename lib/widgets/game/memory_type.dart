import 'package:flutter/material.dart';
import 'package:thinktank_mobile/controller/network_manager.dart';
import 'package:google_fonts/google_fonts.dart';

class MemoryType extends StatelessWidget {
  const MemoryType({super.key, required this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    NetworkManager.currentContext = context;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 8),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 45, 64, 89),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            type,
            style: GoogleFonts.roboto(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
