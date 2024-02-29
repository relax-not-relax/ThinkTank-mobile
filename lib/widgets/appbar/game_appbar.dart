import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TGameAppBar extends StatefulWidget implements PreferredSizeWidget {
  const TGameAppBar({
    super.key,
    required this.preferredHeight,
    required this.userAvatar,
    required this.maxTime,
    required this.gameName,
  });

  final double preferredHeight;
  final String userAvatar;
  final Duration maxTime;
  final String gameName;

  @override
  State<TGameAppBar> createState() => _TGameAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(preferredHeight);
}

class _TGameAppBarState extends State<TGameAppBar> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(20.0),
        bottomRight: Radius.circular(20.0),
      ),
      child: Container(
        height: widget.preferredHeight,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromRGBO(255, 153, 0, 1),
              Color.fromRGBO(234, 67, 53, 1),
            ],
          ),
        ),
        child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 14.0,
            ),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color.fromARGB(
                                255, 255, 255, 255), // Border color
                            width: 3.0, // Border width
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 35, // Avatar radius
                          backgroundImage: NetworkImage(
                              widget.userAvatar), // Your avatar image URL here
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(
                            left: 15.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.gameName,
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
