import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:thinktank_mobile/api/firebase_message_api.dart';
import 'package:thinktank_mobile/api/notification_api.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/notification_item.dart';

class TAppBar extends StatefulWidget implements PreferredSizeWidget {
  const TAppBar({
    super.key,
    required this.onSelectNotification,
    required this.account,
    required this.notiAmount,
  });

  final void Function() onSelectNotification;
  final Account? account;
  final int notiAmount;

  @override
  State<TAppBar> createState() => _TAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(130.0);
}

class _TAppBarState extends State<TAppBar> {
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
                  backgroundImage: widget.account != null
                      ? NetworkImage(widget.account!.avatar!)
                      : const NetworkImage(
                          "https://firebasestorage.googleapis.com/v0/b/thinktank-79ead.appspot.com/o/System%2Favatar-trang-4.jpg?alt=media&token=2ab24327-c484-485a-938a-ed30dc3b1688"),
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
                        widget.account != null ? widget.account!.fullName : "",
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
                  widget.notiAmount == 0
                      ? IconButton(
                          onPressed: () {
                            widget.onSelectNotification();
                          },
                          icon: const Icon(
                            Iconsax.notification,
                            color: Color.fromARGB(255, 255, 212, 96),
                            size: 30.0,
                          ),
                        )
                      : IconButton(
                          onPressed: () {
                            widget.onSelectNotification();
                          },
                          icon: Badge(
                            backgroundColor:
                                const Color.fromARGB(255, 234, 84, 85),
                            label: Text(
                              widget.notiAmount.toString(),
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
}
