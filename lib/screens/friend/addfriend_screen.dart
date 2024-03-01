import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:thinktank_mobile/widgets/others/style_button.dart';
import 'package:unicons/unicons.dart';

class AddFriendScreen extends StatefulWidget {
  const AddFriendScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return AddFriendScreenState();
  }
}

class AddFriendScreenState extends State<AddFriendScreen> {
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
              " Add friends",
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
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
              margin: const EdgeInsets.only(top: 10, left: 15, bottom: 10),
              child: const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  textAlign: TextAlign.start,
                  "User's code",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
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
                  hintText: "User's code",
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
                          Container(
                            margin: const EdgeInsets.only(left: 15),
                            child: Badge(
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
                            child: SizedBox(
                              height: 40,
                              width: 80,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: buttonAdd,
                                child: const Center(
                                  child: Text(
                                    'Add',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color.fromRGBO(205, 205, 205, 1),
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 80,
                      margin: const EdgeInsets.only(top: 10),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 15),
                            child: Badge(
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
                            child: SizedBox(
                              height: 40,
                              width: 100,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: buttonAdded,
                                child: const Center(
                                  child: Text(
                                    'Added',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color.fromRGBO(103, 151, 215, 1),
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 80,
                      margin: const EdgeInsets.only(top: 10),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 15),
                            child: Badge(
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
                            child: SizedBox(
                              height: 40,
                              width: 100,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: buttonFirend,
                                child: const Center(
                                  child: Text(
                                    'Friend',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color.fromRGBO(96, 234, 84, 1),
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
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
}
