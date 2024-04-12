import 'package:flutter/material.dart';
import 'package:thinktank_mobile/screens/friend/friend_screen.dart';
import 'package:thinktank_mobile/screens/home.dart';

class TChallengeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TChallengeAppBar({
    super.key,
    required this.preferredHeight,
  });

  final double preferredHeight;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(20.0),
        bottomRight: Radius.circular(20.0),
      ),
      child: Container(
        height: preferredHeight,
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
        ),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          image: DecorationImage(
            image: AssetImage('assets/pics/challenge_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 50,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const HomeScreen(
                        inputScreen: FriendScreen(),
                        screenIndex: 4,
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
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(preferredHeight);
}
