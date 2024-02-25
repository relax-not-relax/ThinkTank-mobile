import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class TAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TAppBar({
    super.key,
    required this.onSelectNotification,
    required this.urlAvt,
    required this.fullname,
    // required this.title,
    // required this.showBackArrow,
    // required this.leadingIcon,
    // required this.actions,
    // required this.leadingOnPressed,
  });

  // final Widget? title;
  // final bool showBackArrow;
  // final IconData? leadingIcon;
  // final List<Widget> actions;
  // final VoidCallback? leadingOnPressed;
  final void Function() onSelectNotification;
  final String? urlAvt;
  final String fullname;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(20.0),
        bottomRight: Radius.circular(20.0),
      ),
      child: Container(
        color: Colors.transparent,
        height: 140.0,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 4.0,
                sigmaY: 4.0,
              ),
              child: Container(),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
                border: Border.all(color: Colors.white.withOpacity(0.13)),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.15),
                    Colors.white.withOpacity(0.05),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
              child: AppBar(
                backgroundColor: Colors.transparent,
                leading: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(urlAvt!),
                ),
                title: Padding(
                  padding: const EdgeInsets.fromLTRB(7, 0, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Have a nice day",
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        fullname,
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      onSelectNotification();
                    },
                    icon: Badge(
                      backgroundColor: const Color.fromARGB(255, 234, 84, 85),
                      label: Text(
                        "1",
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                        ),
                      ),
                      isLabelVisible: true,
                      child: const Icon(
                        Iconsax.notification,
                        color: Color.fromARGB(255, 255, 212, 96),
                        size: 30.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(130.0);
}
