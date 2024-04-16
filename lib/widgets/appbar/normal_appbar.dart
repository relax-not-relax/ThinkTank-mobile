import 'package:flutter/material.dart';
import 'package:thinktank_mobile/controller/network_manager.dart';
import 'package:google_fonts/google_fonts.dart';

class TNormalAppbar extends StatelessWidget implements PreferredSizeWidget {
  const TNormalAppbar({
    super.key,
    required this.title,
    required this.showBack,
  });

  final String title;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    NetworkManager.currentContext = context;
    return PreferredSize(
      preferredSize: const Size.fromHeight(90.0),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color.fromARGB(103, 129, 140, 155),
              width: 1.0,
            ),
          ),
        ),
        child: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: showBack,
          toolbarHeight: 90.0,
          title: Text(
            title,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(90.0);
}
