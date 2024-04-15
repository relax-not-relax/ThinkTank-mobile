import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:thinktank_mobile/api/friends_api.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/friendship.dart';
import 'package:thinktank_mobile/screens/friend/friend_screen.dart';
import 'package:thinktank_mobile/widgets/others/loadingcustom.dart';
import 'package:thinktank_mobile/widgets/others/spinrer.dart';
import 'package:thinktank_mobile/widgets/others/style_button.dart';

class AddFriendScreen extends StatefulWidget {
  const AddFriendScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return AddFriendScreenState();
  }
}

class AddFriendScreenState extends State<AddFriendScreen> {
  List<Friendship> list = [];
  TextEditingController _codeController = TextEditingController();
  bool _isLoading = false;

  Future<void> search(String code) async {
    if (code.trim().isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      Account? account = await SharedPreferencesHelper.getInfo();
      List<Friendship> listTmp =
          await ApiFriends.searchFriends(1, 1000, account!.id, code, code);
      setState(() {
        list = listTmp;
        _isLoading = false;
      });
    }
  }

  Future<void> add(int index) async {
    LoadingCustom.loading(context);
    Account? account = await SharedPreferencesHelper.getInfo();
    Friendship? fs =
        await ApiFriends.addFriend(account!.id, list[index].accountId2!);
    if (fs != null) {
      setState(() {
        list[index].id = fs.id;
        list[index].status = false;
      });
    }

    LoadingCustom.loaded(context);
  }

  Future<void> denied(int friendShipId, int index) async {
    //_closeDialog(context);
    _showDenyDialog(context);

    await ApiFriends.deleteFriend(friendShipId);

    // ignore: use_build_context_synchronously
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _closeDialog(context);
      }
    });
    setState(() {
      list[index].status = null;
    });
  }

  Future<void> accept(int friendShipId, int index) async {
    //_closeDialog(context);
    _showAcceptDialog(context);

    await ApiFriends.acceptFriend(friendShipId);

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _closeDialog(context);
      }
    });
    setState(() {
      list[index].status = true;
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
            iconTheme: IconThemeData(color: Colors.white),
            title: Text(
              "Add friends",
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
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
                    "User's code or User's name",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
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
                  controller: _codeController,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255)),
                  decoration: InputDecoration(
                    hintStyle: const TextStyle(
                      color: Color.fromRGBO(65, 65, 65, 1),
                    ),
                    hintText: "User's code or User's name",
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
                        size: 30,
                      ),
                      onPressed: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        search(_codeController.text);
                      },
                    ),
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
                                                    element.avatar1!,
                                              ),
                                              fit: BoxFit.cover,
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
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (element.status == null)
                                      Container(
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        child: SizedBox(
                                          height: 40,
                                          width: 80,
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              if (element.status == null) {
                                                await add(
                                                    list.indexOf(element));
                                              }
                                            },
                                            style: buttonAdd,
                                            child: const Center(
                                              child: Text(
                                                'Add',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      205, 205, 205, 1),
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    else if (element.status == false &&
                                        element.accountId1 == null)
                                      Container(
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        child: SizedBox(
                                          height: 40,
                                          width: 100,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              // _showResizableDialog(
                                              //     context,
                                              //     element.userName2!,
                                              //     element.id,
                                              //     list.indexOf(element),
                                              //     "added");
                                              _showConfirmDialog(
                                                context,
                                                () {
                                                  denied(element.id,
                                                      list.indexOf(element));
                                                },
                                                () =>
                                                    Navigator.of(context).pop(),
                                                element.userName2!,
                                                false,
                                              );
                                            },
                                            style: buttonAdded,
                                            child: const Center(
                                              child: Text(
                                                'Added',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      103, 151, 215, 1),
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    else if (element.status == false &&
                                        element.accountId1 != null)
                                      Container(
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        child: SizedBox(
                                          height: 40,
                                          width: 120,
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              // _showResizableDialog(
                                              //     context,
                                              //     element.userName1!,
                                              //     element.id,
                                              //     list.indexOf(element),
                                              //     "approve");
                                              _showConfirmDialog(
                                                context,
                                                () {
                                                  accept(element.id,
                                                      list.indexOf(element));
                                                },
                                                () {
                                                  denied(element.id,
                                                      list.indexOf(element));
                                                },
                                                element.userName1!,
                                                true,
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
                                                  fontSize: 16,
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
                                                  fontSize: 16,
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
}

void _showAcceptDialog(BuildContext context) {
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
                "assets/pics/addfriend.png",
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
                  'The Think Tank community is stronger thanks to you!',
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

void _showDenyDialog(BuildContext context) {
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
                "assets/pics/deny.png",
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
                  "Our friendship failed, it's a pity!",
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

void _showConfirmDialog(BuildContext context, Function accept, Function deny,
    String userName, bool isAdded) {
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
          isAdded
              ? 'Accept $userName as a friend?'
              : 'Cancel friend request to $userName?',
          style: GoogleFonts.roboto(
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _closeDialog(context);
              deny();
            },
            child: Text(
              isAdded ? 'Reject' : 'No',
              style: const TextStyle(
                color: Color.fromRGBO(255, 58, 58, 1),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              _closeDialog(context);
              accept();
            },
            child: Text(
              isAdded ? 'Accept' : 'Yes',
              style: const TextStyle(
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

void _closeDialog(BuildContext context) {
  Navigator.of(context).pop();
}
