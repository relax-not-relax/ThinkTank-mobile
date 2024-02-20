import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:thinktank_mobile/models/notification_item.dart';

class NotificationElement extends StatelessWidget {
  const NotificationElement({
    super.key,
    required this.notiEl,
    required this.onClick,
  });

  final NotificationItem notiEl;
  final void Function() onClick;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 15.0,
        ),
        GestureDetector(
          onTap: () {},
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 14.0,
            ),
            padding: const EdgeInsets.all(15.0),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
              color: Color.fromARGB(255, 44, 44, 44),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 25.0,
                      backgroundImage: AssetImage(notiEl.imgUrl),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(
                          left: 20.0,
                          right: 10.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              notiEl.title,
                              style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 16.0,
                              ),
                            ),
                            Text(
                              notiEl.description,
                              style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: 14.0,
                              ),
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            Text(
                              DateFormat('MMM dd, yyyy').format(notiEl.time),
                              style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 240, 122, 63),
                      radius: 7.0,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
