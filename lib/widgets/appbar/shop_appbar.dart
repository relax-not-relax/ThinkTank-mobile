import 'package:flutter/material.dart';
import 'package:thinktank_mobile/controller/network_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thinktank_mobile/screens/account/account_mainscreen.dart';
import 'package:thinktank_mobile/screens/home.dart';
import 'package:thinktank_mobile/widgets/game/coin_div.dart';

class TShopAppBar extends StatefulWidget implements PreferredSizeWidget {
  const TShopAppBar({
    super.key,
    required this.preferredHeight,
    required this.coins,
  });

  final double preferredHeight;
  final String coins;

  @override
  State<TShopAppBar> createState() => _TShopAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(preferredHeight);
}

class _TShopAppBarState extends State<TShopAppBar> {
  @override
  Widget build(BuildContext context) {
    NetworkManager.currentContext = context;
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(20.0),
        bottomRight: Radius.circular(20.0),
      ),
      child: Container(
        height: widget.preferredHeight,
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
        ),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          image: DecorationImage(
            image: AssetImage('assets/pics/emoji_shop.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const HomeScreen(
                        inputScreen: AccountMainScreen(),
                        screenIndex: 2,
                      );
                    },
                  ),
                );
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 200,
              child: Text(
                "Your memory treasure chest has",
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: const Color.fromARGB(255, 40, 52, 68),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),
              margin: const EdgeInsets.only(
                top: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  10,
                ),
              ),
              child: CoinDiv(
                amount: "${widget.coins} ThinkTank coins",
                color: Colors.black,
                size: 30,
                textSize: 16,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 10,
                ),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(178, 40, 52, 68),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: const Text(
                  "Emoji Shop",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'CustomProFont',
                    color: Colors.white,
                    fontSize: 35,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
