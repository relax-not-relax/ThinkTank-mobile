import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:thinktank_mobile/api/room_api.dart';
import 'package:thinktank_mobile/data/data.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/room.dart';
import 'package:thinktank_mobile/screens/game/game_menu.dart';
import 'package:thinktank_mobile/widgets/others/spinrer.dart';
import 'package:unicons/unicons.dart';

class TRoomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const TRoomAppBar({
    super.key,
    required this.preferredHeight,
    required this.room,
    required this.isOwner,
  });

  final double preferredHeight;
  final Room room;
  final bool isOwner;

  @override
  State<TRoomAppBar> createState() => _TRoomAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(preferredHeight);
}

class _TRoomAppBarState extends State<TRoomAppBar> {
  Account? account = null;
  late Future _initAccount;

  Future<Account?> getAccount() async {
    return await SharedPreferencesHelper.getInfo();
  }

  @override
  void initState() {
    super.initState();
    _initAccount = getAccount();
    _initAccount.then((value) {
      setState(() {
        account = value;
      });
    });
  }

  Future<void> cancelRoom() async {
    _showResizableDialog(context);
    bool status = await ApiRoom.cancelRoom(widget.room.id);
    if (status) {
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) {
            return GameMenuScreen(game: games[4]);
          },
        ),
        (route) => false,
      );
    } else {
      print("Can not cancel!");
      _closeDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    Future displayBottomSheet(BuildContext context) {
      return showModalBottomSheet(
        context: context,
        builder: (context) => Container(
          height: 150,
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 40.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              widget.isOwner
                  ? InkWell(
                      onTap: () {
                        _showCancelDialog(context, cancelRoom, widget.room.name,
                            widget.isOwner);
                      },
                      child: Row(
                        children: [
                          Container(
                            width: 50.0,
                            height: 50.0,
                            //padding: const EdgeInsets.all(20.0),
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 217, 217, 217),
                              borderRadius: BorderRadius.all(
                                Radius.circular(50.0),
                              ),
                            ),
                            child: const Icon(
                              IconlyBold.close_square,
                              color: Color.fromARGB(255, 45, 64, 89),
                              size: 30.0,
                            ),
                          ),
                          const SizedBox(
                            width: 20.0,
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Cancel Room Party",
                                style: GoogleFonts.roboto(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                width: 250,
                                child: Text(
                                  "The room you create will be canceled immediately",
                                  style: GoogleFonts.roboto(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : InkWell(
                      onTap: () {
                        _showCancelDialog(context, cancelRoom, widget.room.name,
                            widget.isOwner);
                      },
                      child: Row(
                        children: [
                          Container(
                            width: 50.0,
                            height: 50.0,
                            //padding: const EdgeInsets.all(20.0),
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 217, 217, 217),
                              borderRadius: BorderRadius.all(
                                Radius.circular(50.0),
                              ),
                            ),
                            child: const Icon(
                              IconlyBold.logout,
                              color: Color.fromARGB(255, 45, 64, 89),
                              size: 30.0,
                            ),
                          ),
                          const SizedBox(
                            width: 20.0,
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Leave room",
                                style: GoogleFonts.roboto(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                width: 250,
                                child: Text(
                                  "You will leave ${widget.room.name} immediately",
                                  style: GoogleFonts.roboto(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      );
    }

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      radius: 40, // Avatar radius
                      backgroundImage: account != null
                          ? NetworkImage(account!.avatar!)
                          : const NetworkImage(
                              "https://firebasestorage.googleapis.com/v0/b/thinktank-79ead.appspot.com/o/System%2Favatar-trang-4.jpg?alt=media&token=2ab24327-c484-485a-938a-ed30dc3b1688",
                            ), // Your avatar image URL here
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          account != null ? "@${account!.userName}" : "",
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          widget.isOwner
                              ? "${widget.room.name} - ID: ${widget.room.code}"
                              : widget.room.name,
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          widget.room.gameName,
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      displayBottomSheet(context);
                    },
                    icon: const Icon(
                      UniconsLine.ellipsis_v,
                      color: Colors.white,
                      size: 30.0,
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

void _showCancelDialog(
    BuildContext context, Function accept, String room, bool isCancel) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          'Confirmation',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: isCancel
            ? Text(
                'Cancel $room Room?',
                style: GoogleFonts.roboto(
                  fontSize: 14,
                ),
              )
            : Text(
                'Leave $room Room?',
                style: GoogleFonts.roboto(
                  fontSize: 14,
                ),
              ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text(
              'No',
              style: TextStyle(
                color: Color.fromARGB(255, 72, 145, 255),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              _closeDialog(context);
              accept();
            },
            child: const Text(
              'Yes',
              style: TextStyle(
                color: Color.fromARGB(255, 72, 145, 255),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      );
    },
  );
}

void _showResizableDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(0),
        content: Container(
          width: 250,
          height: 400,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Color.fromARGB(255, 249, 249, 249)),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Image.asset(
                'assets/pics/cheer.png',
                height: 150,
                width: 150,
              ),
              const SizedBox(height: 10),
              const Text(
                'Please wait...',
                style: TextStyle(
                    color: Color.fromRGBO(234, 84, 85, 1),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const Text(
                'The room party is being cancelled!',
                style: TextStyle(
                    color: Color.fromRGBO(129, 140, 155, 1),
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              const CustomLoadingSpinner(
                  color: Color.fromARGB(255, 245, 149, 24)),
            ],
          ),
        ),
      );
    },
  );
}

void _closeDialog(BuildContext context) {
  Navigator.of(context).pop();
}
