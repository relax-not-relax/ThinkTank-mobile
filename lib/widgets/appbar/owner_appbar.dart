import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thinktank_mobile/data/data.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/screens/game/game_menu.dart';

// ignore: must_be_immutable
class TOwnerAppBar extends StatefulWidget implements PreferredSizeWidget {
  TOwnerAppBar({
    super.key,
    required this.preferredHeight,
  });

  final double preferredHeight;

  @override
  State<TOwnerAppBar> createState() => _TOwnerAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(preferredHeight);
}

class _TOwnerAppBarState extends State<TOwnerAppBar> {
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

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(20.0),
        bottomRight: Radius.circular(20.0),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
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
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return GameMenuScreen(game: games[4]);
                      },
                    ),
                    (route) => false,
                  );
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
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
                    width: 20,
                  ),
                  Expanded(
                    child: account != null
                        ? Text(
                            account!.fullName,
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        : Container(),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
