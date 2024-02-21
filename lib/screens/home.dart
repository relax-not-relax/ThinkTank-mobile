import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/screens/notification/notiscreen.dart';
import 'package:thinktank_mobile/screens/option_home.dart';
import 'package:thinktank_mobile/widgets/appbar/appbar.dart';
import 'package:iconly/iconly.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void openNotification(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NotiScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: TAppBar(
        onSelectNotification: () => openNotification(context),
        urlAvt: '',
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/pics/main_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          child: const OptionScreen(),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 70,
        child: BottomNavigationBar(
          onTap: (value) {},
          currentIndex: 0,
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
              label: 'Account',
            ),
            BottomNavigationBarItem(
              icon: Icon(IconlyLight.star),
              label: 'Achieve',
            ),
            BottomNavigationBarItem(
              icon: Icon(IconlyLight.user_1),
              label: 'Friends',
            ),
          ],
        ),
      ),
    );
  }
}
