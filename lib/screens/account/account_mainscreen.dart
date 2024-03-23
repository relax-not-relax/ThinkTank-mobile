import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:thinktank_mobile/api/authentication_api.dart';
import 'package:thinktank_mobile/api/challenges_api.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/achievement.dart';
import 'package:thinktank_mobile/screens/account/editaccount_screen.dart';
import 'package:thinktank_mobile/screens/achievement/challenges_screen.dart';
import 'package:thinktank_mobile/screens/home.dart';
import 'package:thinktank_mobile/screens/startscreen.dart';
import 'package:thinktank_mobile/widgets/appbar/normal_appbar.dart';
import 'package:thinktank_mobile/widgets/others/itemachieve.dart';
import 'package:thinktank_mobile/widgets/others/spinrer.dart';
import 'package:thinktank_mobile/widgets/others/statistical_item.dart';
import 'package:thinktank_mobile/widgets/others/style_button.dart';

class AccountMainScreen extends StatefulWidget {
  const AccountMainScreen({
    super.key,
  });

  @override
  State<AccountMainScreen> createState() => _AccountMainScreenState();
}

class _AccountMainScreenState extends State<AccountMainScreen> {
  DateTime? registrationDate;
  String? formattedRegistration;
  List<Challenge> list = [];
  List<Challenge> listOfThree = [];
  late Future<void> _getChallenges;
  Account? account = null;
  late Future _initAccount;

  Future<Account?> getAccount() async {
    return await SharedPreferencesHelper.getInfo();
  }

  Future<void> getChallenges() async {
    list = await ApiChallenges.getChallenges();
    if (mounted) {
      setState(() {
        list;
        list.shuffle();
        listOfThree = list.take(3).toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _initAccount = getAccount();
    _initAccount.then((value) {
      setState(() {
        account = value;
        registrationDate = DateTime.parse(account!.registrationDate!);
        formattedRegistration =
            DateFormat('MMMM yyyy').format(registrationDate!);
      });
    });

    _getChallenges = getChallenges();
    _getChallenges.then((value) => {});
  }

  void editAccount() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditAccountScreen(account: account!),
      ),
    ).then((value) {
      _initAccount = getAccount();
      _initAccount.then((value) {
        setState(() {
          account = value;
          registrationDate = DateTime.parse(account!.registrationDate!);
          formattedRegistration =
              DateFormat('MMMM yyyy').format(registrationDate!);
        });
      });

      _getChallenges = getChallenges();
      _getChallenges.then((value) => {});
    });
  }

  List<Color> backgroundColors = [
    const Color.fromRGBO(250, 205, 67, 1),
    const Color.fromRGBO(189, 155, 255, 1),
    const Color.fromRGBO(255, 176, 176, 1),
    const Color.fromRGBO(219, 255, 191, 1),
    const Color.fromRGBO(118, 195, 223, 1),
    const Color.fromRGBO(155, 85, 154, 1),
    const Color.fromRGBO(248, 171, 127, 1),
    const Color.fromRGBO(203, 91, 91, 1),
    const Color.fromRGBO(146, 166, 250, 1),
    const Color.fromRGBO(89, 205, 209, 1)
  ];
  List<Color> shadowColors = [
    const Color.fromRGBO(235, 165, 0, 1),
    const Color.fromRGBO(152, 102, 250, 1),
    const Color.fromRGBO(255, 122, 122, 1),
    const Color.fromRGBO(186, 255, 133, 1),
    const Color.fromRGBO(89, 177, 209, 1),
    const Color.fromRGBO(137, 52, 136, 1),
    const Color.fromRGBO(255, 140, 75, 1),
    const Color.fromRGBO(175, 48, 48, 1),
    const Color.fromRGBO(114, 135, 225, 1),
    const Color.fromARGB(255, 68, 190, 194),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: account != null
          ? TNormalAppbar(title: "@${account!.userName}")
          : TNormalAppbar(title: "@"),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 7,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              account != null ? account!.fullName : "",
                              style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              account != null ? account!.code : "",
                              style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              "Joined ${formattedRegistration ?? ""}",
                              style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: CircleAvatar(
                            backgroundImage: account != null
                                ? NetworkImage(account!.avatar!)
                                : const NetworkImage(
                                    "https://firebasestorage.googleapis.com/v0/b/thinktank-79ead.appspot.com/o/System%2Favatar-trang-4.jpg?alt=media&token=2ab24327-c484-485a-938a-ed30dc3b1688",
                                  ),
                            radius: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 7,
                        child: ElevatedButton(
                          onPressed: () {
                            editAccount();
                          },
                          style: buttonPrimary_2,
                          child: Text(
                            "Edit Profile",
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () async {
                            _showResizableDialog(context);
                            bool status = await ApiAuthentication.logOut();
                            if (status) {
                              // ignore: use_build_context_synchronously
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => StartScreen()),
                                (route) => false,
                              );
                            } else {
                              print("Loi logout");
                              _closeDialog(context);
                            }
                          },
                          style: buttonLogout,
                          child: const Icon(
                            IconlyLight.logout,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40.0,
                ),
                const Divider(
                  height: 20,
                  thickness: 1,
                  color: Color.fromARGB(132, 129, 140, 155),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Statistical",
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 8,
                        child: StatisticalItem(
                            imgPath: "assets/pics/TTcoin.png",
                            title: "3222",
                            description: "Coins"),
                      ),
                      Expanded(
                        child: SizedBox(
                          width: 5,
                        ),
                      ),
                      Expanded(
                        flex: 8,
                        child: StatisticalItem(
                            imgPath: "assets/pics/medal.png",
                            title: "10",
                            description: "Times in top 3"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Missions",
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Container(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  padding: const EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromRGBO(116, 116, 116, 1),
                          width: 0.8,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        children: [
                          ...listOfThree
                              .map(
                                (e) => ItemAchieveAccount(
                                  imgLink: e.missionsImg,
                                  backgroundColor:
                                      backgroundColors[listOfThree.indexOf(e)],
                                  shadowColor:
                                      shadowColors[listOfThree.indexOf(e)],
                                  title: e.name,
                                  description: e.description,
                                  progress: (e.completedLevel == null)
                                      ? 0
                                      : e.completedLevel!,
                                  total: e.completedMilestone,
                                  recived:
                                      (e.status == null) ? false : e.status!,
                                ),
                              )
                              .toList(),
                          list.isNotEmpty
                              ? Container(
                                  height: 1,
                                  width: MediaQuery.of(context).size.width,
                                  color: const Color.fromRGBO(116, 116, 116, 1),
                                )
                              : Container(),
                          InkWell(
                            onTap: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomeScreen(
                                    inputScreen: ChallengesScreen(),
                                    screenIndex: 3,
                                  ),
                                ),
                                (route) => false,
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 20,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  list.isNotEmpty
                                      ? Text(
                                          "${list.length - 3} other missons",
                                          style: GoogleFonts.roboto(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Text(
                                          "0 other missons",
                                          style: GoogleFonts.roboto(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                  const Icon(
                                    IconlyLight.arrow_right_2,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void _closeDialog(BuildContext context) {
  Navigator.of(context).pop();
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
                'assets/pics/accOragne.png',
                height: 150,
                width: 150,
              ),
              const SizedBox(height: 10),
              const Text(
                'Please wait...',
                style: TextStyle(
                    color: Color.fromRGBO(234, 84, 85, 1),
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              const Text(
                'Please wait a moment, Logouting...',
                style: TextStyle(
                    color: Color.fromRGBO(129, 140, 155, 1),
                    fontSize: 18,
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
