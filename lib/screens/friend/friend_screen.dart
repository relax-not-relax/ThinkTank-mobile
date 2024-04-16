import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:thinktank_mobile/controller/network_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:thinktank_mobile/api/friends_api.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/friend_response.dart';
import 'package:thinktank_mobile/models/friendship.dart';
import 'package:thinktank_mobile/screens/friend/addfriend_screen.dart';
import 'package:thinktank_mobile/screens/friend/challenge_player_screen.dart';
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
  late Future<FriendResponse> _getFriendship;
  TextEditingController _codeController = TextEditingController();
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
  List<Friendship> list = [];
  List<Friendship> listTmp = [];
  bool _isLoading = true;
  bool hasRequest = false;
  int pageIndex = 1;
  late ScrollController _scrollController;

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
    _closeDialog(context);
    _showResizableDialog(context);

    await ApiFriends.deleteFriend(friendShipId);
    await refreshFriends();
    // ignore: use_build_context_synchronously
    _closeDialog(context);
  }

  Future<FriendResponse> getFriendShip() async {
    hasRequest = (await ApiFriends.searchRequest(1, 1000, ""))
        .where((element) => element.userName1 != null)
        .isNotEmpty;
    if (mounted) {
      setState(() {
        hasRequest = hasRequest;
      });
    }

    FriendResponse friendResponse = await ApiFriends.getFriends(pageIndex, 4);

    return friendResponse;
  }

  Future<void> refreshFriends() async {
    setState(() {
      _isLoading = true;
    });

    FriendResponse friendResponse = await ApiFriends.getFriends(pageIndex, 4);
    setState(() {
      list = friendResponse.friends;
      listTmp = friendResponse.friends;
      countFriend = listTmp.length;
      _isLoading = false;
    });
  }

  int countFriend = 0;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _getFriendship = getFriendShip();
    _getFriendship.then((friend) {
      if (mounted) {
        setState(() {
          list = friend.friends;
          listTmp = friend.friends;
          countFriend = friend.totalNumberOfRecords;
          _isLoading = false;
        });
      }
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      loadMore();
    }
  }

  Future<void> loadMore() async {
    setState(() {
      pageIndex = pageIndex + 1;
    });
    print("Loading more data...$pageIndex");
    FriendResponse friendResponse = await ApiFriends.getFriends(pageIndex, 4);
    list.addAll(friendResponse.friends);
    setState(() {
      list;
    });
  }

  @override
  Widget build(BuildContext context) {
    NetworkManager.currentContext = context;
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
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
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

                    hasRequest = (await ApiFriends.searchRequest(1, 1000, ""))
                        .where((element) => element.userName1 != null)
                        .isNotEmpty;
                    setState(() {
                      hasRequest = hasRequest;
                    });
                    _getFriendship = getFriendShip();
                    _getFriendship.then((friend) {
                      if (mounted) {
                        setState(() {
                          list = friend.friends;
                          listTmp = friend.friends;
                          countFriend = friend.totalNumberOfRecords;
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
            ],
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: RefreshIndicator(
          onRefresh: refreshFriends,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 0, 0, 0),
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    height: 195,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/pics/friendbg.png'),
                        fit: BoxFit.cover,
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
                        width: MediaQuery.of(context).size.width * 0.8,
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(65, 65, 65, 1),
                                  width: 1.0),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(65, 65, 65, 1),
                                  width: 1.0),
                            ),
                            prefixIcon: IconButton(
                              icon: const Icon(
                                IconlyLight.search,
                                size: 30,
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

                              hasRequest = (await ApiFriends.searchRequest(
                                      1, 1000, ""))
                                  .where((element) => element.userName1 != null)
                                  .isNotEmpty;
                              setState(() {
                                hasRequest = hasRequest;
                              });
                              _getFriendship.then((friend) {
                                if (mounted) {
                                  setState(() {
                                    list = friend.friends;
                                    listTmp = friend.friends;
                                    countFriend = friend.totalNumberOfRecords;
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
                            child: CustomLoadingSpinner(
                                color: Color.fromARGB(255, 245, 149, 24)),
                          )
                        : SingleChildScrollView(
                            controller: _scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Column(
                              children: [
                                for (var fs in list)
                                  Container(
                                    height: 80,
                                    margin: const EdgeInsets.only(
                                      top: 10,
                                      left: 10,
                                    ),
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        StreamBuilder<DatabaseEvent>(
                                          stream: _databaseReference
                                              .child('online')
                                              .child((fs.accountId1 ??
                                                      fs.accountId2)
                                                  .toString())
                                              .onValue,
                                          builder: (context,
                                              AsyncSnapshot<DatabaseEvent>
                                                  snapshot) {
                                            if (snapshot.hasData &&
                                                snapshot.data!.snapshot.value !=
                                                    null) {
                                              print(snapshot
                                                      .data!.snapshot.value!
                                                      .toString() +
                                                  "messi");
                                              bool isOnline = bool.parse(
                                                  snapshot.data!.snapshot.value!
                                                      .toString());
                                              return Badge(
                                                label: const SizedBox(
                                                  height: 8,
                                                  width: 8,
                                                ),
                                                alignment:
                                                    Alignment.bottomRight,
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
                                                        BorderRadius.circular(
                                                            100),
                                                    border: Border.all(
                                                        color: Colors.black),
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                        fs.avatar2 ??
                                                            fs.avatar1!,
                                                      ),
                                                      fit: BoxFit.cover,
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
                                                alignment:
                                                    Alignment.bottomRight,
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        0, 255, 193, 7),
                                                isLabelVisible: true,
                                                child: Container(
                                                  height: 60,
                                                  width: 60,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    border: Border.all(
                                                        color: Colors.black),
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                        fs.avatar2 ??
                                                            fs.avatar1!,
                                                      ),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                        Expanded(
                                          child: Container(
                                            margin:
                                                const EdgeInsets.only(left: 20),
                                            child: Text(
                                              fs.userName2 ?? fs.userName1!,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(right: 10),
                                          child: IconButton(
                                            icon: const Icon(
                                                UniconsLine.ellipsis_h),
                                            color: Colors.white,
                                            onPressed: () {
                                              displayBottomSheet(
                                                  context,
                                                  fs.userName2 ?? fs.userName1!,
                                                  listTmp.indexOf(fs),
                                                  fs.id,
                                                  fs.accountId2 == 0
                                                      ? fs.accountId1!
                                                      : fs.accountId2!);
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
        ),
      ),
    );
  }

  Future displayBottomSheet(BuildContext context, String userName, int index,
      int friendShipId, int compeID) {
    return showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 200,
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 40.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                _showConfirmDialog(context, () {
                  denied(
                    friendShipId,
                    index,
                  );
                }, userName);
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
            const SizedBox(
              height: 15.0,
            ),
            InkWell(
              onTap: () {
                print(compeID);
                //Trong truong hop nguoi choi thach dau dang offline
                //_closeDialog(context);
                //_showResizableDialogOffline(context);

                //Trong truong hop nguoi choi thach dau dang online
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      //Sua theo id cua friend
                      return ChallengePlayerScreen(
                        competitorId: compeID,
                      );
                    },
                  ),
                );
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
                      IconlyBold.game,
                      color: Color.fromARGB(255, 45, 64, 89),
                      size: 30.0,
                    ),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Text(
                    "Challenge player",
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

void _showConfirmDialog(
    BuildContext context, Function accept, String userName) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          'Confirmation',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Remove $userName as a friend?',
          style: GoogleFonts.roboto(
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text(
              'No',
              style: TextStyle(
                color: Color.fromARGB(255, 72, 145, 255),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              _closeDialog(context);
              accept();
            },
            child: const Text(
              'Yes',
              style: TextStyle(
                color: Color.fromARGB(255, 72, 145, 255),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      );
    },
  );
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
                "assets/pics/logout.png",
                height: 150,
                width: 150,
              ),
              const SizedBox(height: 10),
              const Text(
                'Please wait...',
                style: TextStyle(
                    color: Color.fromRGBO(234, 84, 85, 1),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 14,
                ),
                child: Text(
                  'So our last time together was bitter but not painful',
                  style: TextStyle(
                      color: Color.fromRGBO(129, 140, 155, 1),
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
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

void _showResizableDialogOffline(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(0),
        content: Container(
          width: 250,
          height: 300,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Color.fromARGB(255, 249, 249, 249)),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Image.asset(
                'assets/pics/offline.png',
                height: 150,
                width: 150,
              ),
              const SizedBox(height: 10),
              const Text(
                'Oh no!',
                style: TextStyle(
                    color: Color.fromRGBO(234, 84, 85, 1),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 5,
                ),
                child: Text(
                  "The player is offline!",
                  style: TextStyle(
                      color: Color.fromRGBO(129, 140, 155, 1),
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void _closeDialog(BuildContext context) {
  Navigator.of(context).pop();
}
