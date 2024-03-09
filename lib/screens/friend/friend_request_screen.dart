import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:thinktank_mobile/api/friends_api.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/friendship.dart';
import 'package:thinktank_mobile/widgets/others/loadingcustom.dart';
import 'package:thinktank_mobile/widgets/others/spinrer.dart';
import 'package:thinktank_mobile/widgets/others/style_button.dart';
import 'package:unicons/unicons.dart';

class FriendRequestScreen extends StatefulWidget {
  const FriendRequestScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return FriendRequestScreenState();
  }
}

class FriendRequestScreenState extends State<FriendRequestScreen> {
  List<Friendship> list = [];
  List<Friendship> listTmp = [];
  TextEditingController _codeController = TextEditingController();
  bool _isLoading = true;

  Future<void> search(String username) async {
    setState(() {
      list = listTmp
          .where((element) =>
              element.userName1 != null &&
              element.userName1!.contains(username))
          .toList();
    });
  }

  Future<List<Friendship>> getListRequest() async {
    Account? account = await SharedPreferencesHelper.getInfo();
    listTmp = await ApiFriends.searchRequest(
        1, 1000, account!.id, "", account.accessToken);
    return listTmp.where((element) => element.accountId1 != null).toList();
  }

  late Future<List<Friendship>> _getRequest;

  Future<void> accept(int friendShipId, int index) async {
    LoadingCustom.loading(context);
    Account? account = await SharedPreferencesHelper.getInfo();
    setState(() {
      listTmp.removeAt(index);
      list = listTmp
          .where((element) =>
              element.userName1 != null &&
              element.userName1!.contains(_codeController.text))
          .toList();
    });
    await ApiFriends.acceptFriend(friendShipId, account!.accessToken);
    // ignore: use_build_context_synchronously
    LoadingCustom.loaded(context);
  }

  Future<void> denied(int friendShipId, int index) async {
    LoadingCustom.loading(context);
    Account? account = await SharedPreferencesHelper.getInfo();
    setState(() {
      listTmp.removeAt(index);
      list = listTmp
          .where((element) =>
              element.userName1 != null &&
              element.userName1!.contains(_codeController.text))
          .toList();
    });
    await ApiFriends.deleteFriend(friendShipId, account!.accessToken);
    // ignore: use_build_context_synchronously
    LoadingCustom.loaded(context);
  }

  int countFriend = 0;
  @override
  void initState() {
    super.initState();
    _getRequest = getListRequest();
    _getRequest.then((listFriend) {
      setState(() {
        if (listFriend.isNotEmpty) {
          list = listFriend;
        }
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90.0),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
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
                "Friend requests",
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              centerTitle: true,
            ),
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
                    "Username",
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
                    hintText: "Username",
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
                        search(_codeController.text);
                      },
                    ),
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
                            for (var element in list)
                              Container(
                                height: 80,
                                margin: const EdgeInsets.only(top: 10),
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(left: 15),
                                      child: Badge(
                                        label: const SizedBox(
                                          height: 10,
                                          width: 10,
                                        ),
                                        alignment: Alignment.bottomRight,
                                        backgroundColor: const Color.fromARGB(
                                            0, 97, 234, 84),
                                        isLabelVisible: true,
                                        child: Container(
                                          height: 60,
                                          width: 60,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            border:
                                                Border.all(color: Colors.black),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  element.avatar2 ??
                                                      element.avatar1!),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 20),
                                        child: Text(
                                          element.userName2 ??
                                              element.userName1!,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (element.status == false &&
                                        element.accountId1 != null)
                                      Container(
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        child: SizedBox(
                                          height: 40,
                                          width: 120,
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              _showResizableDialog(
                                                context,
                                                element.userName1!,
                                                element.id,
                                                listTmp.indexOf(element),
                                              );
                                            },
                                            style: buttonApprove,
                                            child: const Center(
                                              child: Text(
                                                'Approve',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      255, 212, 96, 1),
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    else
                                      Container(
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        child: SizedBox(
                                          height: 40,
                                          width: 100,
                                          child: ElevatedButton(
                                            onPressed: () {},
                                            style: buttonFriend,
                                            child: const Center(
                                              child: Text(
                                                'Friend',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      96, 234, 84, 1),
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
      ),
    );
  }

  void _showResizableDialog(
      BuildContext context, String username, int friendShipId, int index) {
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
                      'Accept $username as a friend',
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
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(
                            color: Color.fromARGB(255, 202, 202, 202),
                            width: 1),
                      ),
                    ),
                    margin: const EdgeInsets.only(
                      bottom: 10,
                    ),
                    padding: const EdgeInsets.only(top: 10),
                    child: Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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
                                  'Rejecte',
                                  style: TextStyle(
                                    color: Color.fromRGBO(255, 58, 58, 1),
                                    fontSize: 20,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              Navigator.pop(context);
                              await accept(friendShipId, index);
                            },
                            child: const SizedBox(
                              height: 50,
                              width: 125,
                              child: Center(
                                child: Text(
                                  'Accept',
                                  style: TextStyle(
                                    color: Color.fromRGBO(72, 145, 255, 1),
                                    fontSize: 20,
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
