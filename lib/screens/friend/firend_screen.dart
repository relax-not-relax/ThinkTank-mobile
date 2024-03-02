import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:thinktank_mobile/screens/friend/addfriend_screen.dart';
import 'package:thinktank_mobile/widgets/others/spinrer.dart';
import 'package:unicons/unicons.dart';

class FriendScreen extends StatefulWidget {
  const FriendScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return FriendScreenState();
  }
}

void _showResizableDialog(BuildContext context, String username) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(0),
        content: Container(
          width: 250,
          height: 140,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Color.fromARGB(255, 249, 249, 249)),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'Remove $username as a friend',
                    style: const TextStyle(
                        color: Color.fromRGBO(129, 140, 155, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(
                    bottom: 10,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            print('No');
                          },
                          child: const SizedBox(
                            height: 50,
                            width: 125,
                            child: Center(
                              child: Text(
                                'No',
                                style: TextStyle(
                                  color: Color.fromRGBO(72, 145, 255, 1),
                                  fontSize: 25,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            print('Yes');
                          },
                          child: const SizedBox(
                            height: 50,
                            width: 125,
                            child: Center(
                              child: Text(
                                'Yes',
                                style: TextStyle(
                                  color: Color.fromRGBO(72, 145, 255, 1),
                                  fontSize: 25,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}

class FriendScreenState extends State<FriendScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90.0),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color.fromARGB(103, 129, 140, 155),
                width: 1.0,
              ),
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.black,
            toolbarHeight: 90.0,
            title: Text(
              "Friends",
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddFriendScreen(),
                    ),
                  );
                },
                icon: const Icon(
                  IconlyBold.plus,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 0, 0, 0),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20),
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width - 20,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/pics/friendbg.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width - 20,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(18, 19, 21, 1),
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: TextField(
                style:
                    const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                decoration: InputDecoration(
                  hintStyle: const TextStyle(
                    color: Color.fromRGBO(65, 65, 65, 1),
                  ),
                  hintText: 'Search friends',
                  contentPadding: const EdgeInsets.all(20),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide(
                        color: Color.fromRGBO(65, 65, 65, 1), width: 1.0),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide(
                        color: Color.fromRGBO(65, 65, 65, 1), width: 1.0),
                  ),
                  prefixIcon: IconButton(
                    icon: const Icon(
                      IconlyLight.search,
                      size: 35,
                    ),
                    onPressed: () {
                      setState(() {});
                    },
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 10,
                left: 20,
              ),
              child: const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  '10 Friends',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 80,
                      margin: const EdgeInsets.only(top: 10),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Badge(
                            label: const SizedBox(
                              height: 10,
                              width: 10,
                            ),
                            alignment: Alignment.bottomRight,
                            backgroundColor:
                                const Color.fromRGBO(96, 234, 84, 1),
                            isLabelVisible: true,
                            child: CircleAvatar(
                              radius: 30,
                              child: Image.asset(
                                'assets/pics/cup.png',
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(left: 20),
                              child: const Text(
                                'Đỗ Hoàng Huy',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: IconButton(
                              icon: const Icon(UniconsLine.ellipsis_h),
                              color: Colors.white,
                              onPressed: () {
                                displayBottomSheet(context, 'Đỗ Hoàng Huy');
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future displayBottomSheet(BuildContext context, String useranme) {
    return showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 130,
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 40.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                _showResizableDialog(context, useranme);
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
                      Iconsax.user_minus,
                      color: Color.fromARGB(255, 45, 64, 89),
                      size: 30.0,
                    ),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Text(
                    "Mark All As Read",
                    style: GoogleFonts.roboto(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
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
