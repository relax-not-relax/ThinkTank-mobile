import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:thinktank_mobile/api/friends_api.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/friendship.dart';
import 'package:thinktank_mobile/screens/friend/addfriend_screen.dart';
import 'package:thinktank_mobile/screens/friend/friend_request_screen.dart';
import 'package:thinktank_mobile/widgets/others/loadingcustom.dart';
import 'package:thinktank_mobile/widgets/others/spinrer.dart';
import 'package:unicons/unicons.dart';

class FriendScreen extends StatefulWidget {
  const FriendScreen({super.key});
  @override
  State<StatefulWidget> createState() {
    // ignore: no_logic_in_create_state
    return FriendScreenState();
  }
}

class FriendScreenState extends State<FriendScreen> {
  late Future<List<Friendship>> _getFriensship;
  TextEditingController _codeController = TextEditingController();
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
  List<Friendship> list = [];
  List<Friendship> listTmp = [];
  bool _isLoading = true;
  bool hasRequest = false;
  Future<void> search(String username) async {
    setState(() {
      list = listTmp
          .where((element) =>
              (element.userName2 != null &&
                  element.userName2!.contains(username)) ||
              (element.userName1 != null &&
                  element.userName1!.contains(username)))
          .toList();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> denied(int friendShipId, int index) async {
    LoadingCustom.loading(context);
    Account? account = await SharedPreferencesHelper.getInfo();
    setState(() {
      listTmp.removeAt(index);
      list = listTmp
          .where((element) =>
              element.userName2 != null &&
              element.userName2!.contains(_codeController.text))
          .toList();
      countFriend = listTmp.length;
    });
    await ApiFriends.deleteFriend(friendShipId, account!.accessToken!);
    LoadingCustom.loaded(context);
    Navigator.pop(context);
  }

  Future<List<Friendship>> getFriendShip() async {
    Account? account = await SharedPreferencesHelper.getInfo();
    hasRequest = (await ApiFriends.searchRequest(
            1, 1000, account!.id, "", account.accessToken!))
        .where((element) => element.userName1 != null)
        .isNotEmpty;
    if (mounted) {
      setState(() {
        hasRequest = hasRequest;
      });
    }
    return ApiFriends.getFriends(
      1,
      1000,
      account!.id,
      account.accessToken!,
    );
  }

  int countFriend = 0;
  @override
  void initState() {
    super.initState();
    _getFriensship = getFriendShip();
    _getFriensship.then((listFriend) {
      if (mounted) {
        setState(() {
          if (listFriend.isNotEmpty) {
            list = listFriend;
            listTmp = listFriend;
            countFriend = listTmp.length;
          }
          _isLoading = false;
        });
      }
    });
  }

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
                onPressed: () {},
                icon: IconButton(
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FriendRequestScreen(),
                      ),
                    ).then((result) async {
                      setState(() {
                        _isLoading = true;
                      });

                      Account? account =
                          await SharedPreferencesHelper.getInfo();
                      hasRequest = (await ApiFriends.searchRequest(
                              1, 1000, account!.id, "", account.accessToken!))
                          .where((element) => element.userName1 != null)
                          .isNotEmpty;
                      setState(() {
                        hasRequest = hasRequest;
                      });
                      _getFriensship = ApiFriends.getFriends(
                        1,
                        1000,
                        account!.id,
                        account.accessToken!,
                      );
                      _getFriensship.then((listFriend) {
                        if (mounted) {
                          setState(() {
                            list = listFriend;
                            listTmp = listFriend;
                            countFriend = listTmp.length;
                            _isLoading = false;
                          });
                        }
                      });
                    });
                  },
                  icon: Badge(
                    alignment: Alignment.bottomRight,
                    backgroundColor: !hasRequest
                        ? const Color.fromARGB(0, 255, 193, 7)
                        : const Color.fromARGB(255, 234, 84, 85),
                    label: const SizedBox(
                      height: 8,
                      width: 8,
                    ),
                    isLabelVisible: true,
                    child: const Icon(
                      Iconsax.notification,
                      color: Color.fromARGB(255, 255, 255, 255),
                      size: 30.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 0, 0, 0),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20),
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/pics/friendbg.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(18, 19, 21, 1),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: TextField(
                      onChanged: (value) {
                        search(value);
                      },
                      controller: _codeController,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255)),
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
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 5),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddFriendScreen(),
                          ),
                        ).then((result) async {
                          setState(() {
                            _isLoading = true;
                          });

                          Account? account =
                              await SharedPreferencesHelper.getInfo();
                          hasRequest = (await ApiFriends.searchRequest(1, 1000,
                                  account!.id, "", account.accessToken!))
                              .where((element) => element.userName1 != null)
                              .isNotEmpty;
                          setState(() {
                            hasRequest = hasRequest;
                          });
                          _getFriensship = ApiFriends.getFriends(
                            1,
                            1000,
                            account!.id,
                            account.accessToken!,
                          );
                          _getFriensship.then((listFriend) {
                            if (mounted) {
                              setState(() {
                                list = listFriend;
                                listTmp = listFriend;
                                countFriend = listTmp.length;
                                _isLoading = false;
                              });
                            }
                          });
                        });
                      },
                      child: const Icon(
                        IconlyBold.add_user,
                        color: Color.fromARGB(255, 255, 255, 255),
                        size: 30.0,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(
                  top: 20,
                  left: 10,
                ),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    '$countFriend Friends',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CustomLoadingSpinner(),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            for (var fs in list)
                              Container(
                                height: 80,
                                margin: const EdgeInsets.only(top: 10),
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    StreamBuilder<DatabaseEvent>(
                                      stream: _databaseReference
                                          .child('online')
                                          .child(
                                              (fs.accountId1 ?? fs.accountId2)
                                                  .toString())
                                          .onValue,
                                      builder: (context,
                                          AsyncSnapshot<DatabaseEvent>
                                              snapshot) {
                                        if (snapshot.hasData &&
                                            snapshot.data!.snapshot.value !=
                                                null) {
                                          print(snapshot.data!.snapshot.value!
                                                  .toString() +
                                              "messi");
                                          bool isOnline = bool.parse(snapshot
                                              .data!.snapshot.value!
                                              .toString());
                                          return Badge(
                                            label: const SizedBox(
                                              height: 8,
                                              width: 8,
                                            ),
                                            alignment: Alignment.bottomRight,
                                            backgroundColor: isOnline
                                                ? const Color.fromRGBO(
                                                    96, 234, 84, 1)
                                                : const Color.fromARGB(
                                                    0, 255, 193, 7),
                                            isLabelVisible: true,
                                            child: Container(
                                              height: 60,
                                              width: 60,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                border: Border.all(
                                                    color: Colors.black),
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                      fs.avatar2 ??
                                                          fs.avatar1!),
                                                ),
                                              ),
                                            ),
                                          );
                                        } else {
                                          return Badge(
                                            label: const SizedBox(
                                              height: 8,
                                              width: 8,
                                            ),
                                            alignment: Alignment.bottomRight,
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    0, 255, 193, 7),
                                            isLabelVisible: true,
                                            child: Container(
                                              height: 60,
                                              width: 60,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                border: Border.all(
                                                    color: Colors.black),
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                      fs.avatar2 ??
                                                          fs.avatar1!),
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 20),
                                        child: Text(
                                          fs.userName2 ?? fs.userName1!,
                                          style: const TextStyle(
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
                                        icon:
                                            const Icon(UniconsLine.ellipsis_h),
                                        color: Colors.white,
                                        onPressed: () {
                                          displayBottomSheet(
                                              context,
                                              fs.userName2 ?? fs.userName1!,
                                              listTmp.indexOf(fs),
                                              fs.id);
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
      ),
    );
  }

  Future displayBottomSheet(
      BuildContext context, String useranme, int index, int friendShipId) {
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
                _showResizableDialog(context, useranme, index, friendShipId);
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
                    "Remove this friendship",
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

  void _showResizableDialog(
      BuildContext context, String username, int index, int friendShipId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          content: Container(
            width: 250,
            height: 140,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
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
                              Navigator.pop(context);
                              Navigator.pop(context);
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
                            onTap: () async {
                              Navigator.pop(context);
                              await denied(friendShipId, index);
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
}
