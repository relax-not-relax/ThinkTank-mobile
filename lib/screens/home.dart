// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thinktank_mobile/api/assets_api.dart';
import 'package:thinktank_mobile/api/friends_api.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/screens/account/account_mainscreen.dart';
import 'package:thinktank_mobile/screens/analytics/memory_mainscreen.dart';
//import 'package:thinktank_mobile/screens/analytics/memory_mainscreen.dart';
import 'package:thinktank_mobile/screens/friend/friend_screen.dart';
import 'package:thinktank_mobile/screens/achievement/challenges_screen.dart';
import 'package:thinktank_mobile/screens/notification/notiscreen.dart';
import 'package:thinktank_mobile/screens/option_home.dart';
import 'package:thinktank_mobile/widgets/appbar/appbar.dart';
import 'package:iconly/iconly.dart';
import 'package:thinktank_mobile/widgets/others/loadingcustom.dart';
import 'package:thinktank_mobile/widgets/others/spinrer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.inputScreen,
    required this.screenIndex,
  });

  //final Account account;
  final Widget inputScreen;
  final int screenIndex;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedPageIndex = widget.screenIndex;
  }

  void _selectPage(int index) async {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = widget.inputScreen;

    switch (_selectedPageIndex) {
      case 0:
        activePage = OptionScreen();
        break;
      case 1:
        //activePage = MemoryMainScreen();
        break;
      case 4:
        activePage = const FriendScreen();
        break;
      case 2:
        activePage = const AccountMainScreen();
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
              activeIcon: Icon(IconlyBold.chart),
              label: 'Chart',
            ),
            BottomNavigationBarItem(
              icon: Icon(IconlyLight.profile),
              activeIcon: Icon(IconlyBold.profile),
              label: 'Account',
            ),
            BottomNavigationBarItem(
              icon: Icon(IconlyLight.star),
              activeIcon: Icon(IconlyBold.star),
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
