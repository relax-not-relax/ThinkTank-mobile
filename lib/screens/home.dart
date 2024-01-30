import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thinktank_mobile/widgets/appbar/appbar.dart';
import 'package:iconly/iconly.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(),
      body: const SingleChildScrollView(),
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
