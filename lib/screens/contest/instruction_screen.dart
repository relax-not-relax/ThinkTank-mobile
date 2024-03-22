import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thinktank_mobile/data/data.dart';

class InstructionScreen extends StatelessWidget {
  const InstructionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 50,
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    Text(
                      'CONTEST RULES',
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'ButtonCustomFont',
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 10
                          ..color = Color.fromARGB(255, 255, 213, 96),
                      ),
                    ),
                    // Lớp văn bản chính
                    const Text(
                      'CONTEST RULES',
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'ButtonCustomFont',
                        color: Color.fromARGB(255, 240, 122, 63),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 28,
                child: Text(
                  "We create contests so users can compete together. Through contests, players can collect ThinkTank coins in attractive amounts. In addition, players can challenge themselves with different easy and difficult problems through different topics.",
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Games may be included in the contest:",
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
