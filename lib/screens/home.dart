// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thinktank_mobile/api/friends_api.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/screens/account/account_mainscreen.dart';
import 'package:thinktank_mobile/screens/friend/friend_screen.dart';
import 'package:thinktank_mobile/screens/achievement/challenges_screen.dart';
import 'package:thinktank_mobile/screens/notification/notiscreen.dart';
import 'package:thinktank_mobile/screens/option_home.dart';
import 'package:thinktank_mobile/widgets/appbar/appbar.dart';
import 'package:iconly/iconly.dart';
import 'package:thinktank_mobile/widgets/others/loadingcustom.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.account});

  final Account account;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) async {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = OptionScreen(
      account: widget.account,
    );

    switch (_selectedPageIndex) {
      case 4:
        activePage = const FriendScreen();
        break;
      case 2:
        activePage = AccountMainScreen(
          account: widget.account,
        );
        break;
      case 3:
        activePage = ChallengesScreen();
        break;
    }

    return Scaffold(
      body: activePage,
      bottomNavigationBar: SizedBox(
        height: 70,
        child: BottomNavigationBar(
          onTap: _selectPage,
          currentIndex: _selectedPageIndex,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.white,
          selectedLabelStyle: GoogleFonts.roboto(
            fontSize: 13.0,
            fontWeight: FontWeight.w500,
          ),
          unselectedItemColor: const Color.fromARGB(255, 136, 136, 136),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(IconlyLight.home),
              activeIcon: Icon(IconlyBold.home),
              label: 'Home',
              backgroundColor: Color.fromARGB(255, 0, 0, 0),
            ),
            BottomNavigationBarItem(
              icon: Icon(IconlyLight.chart),
              label: 'Chart',
            ),
            BottomNavigationBarItem(
              icon: Icon(IconlyLight.profile),
              activeIcon: Icon(IconlyBold.profile),
              label: 'Account',
            ),
            BottomNavigationBarItem(
              icon: Icon(IconlyLight.star),
              label: 'Achieve',
            ),
            BottomNavigationBarItem(
              icon: Icon(IconlyLight.user_1),
              activeIcon: Icon(IconlyBold.user_3),
              label: 'Friends',
            ),
          ],
        ),
      ),
    );
  }
}
