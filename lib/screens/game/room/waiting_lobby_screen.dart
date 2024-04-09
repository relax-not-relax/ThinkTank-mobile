import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:thinktank_mobile/data/data.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/account_in_room.dart';
import 'package:thinktank_mobile/models/room.dart';
import 'package:thinktank_mobile/widgets/appbar/room_appbar.dart';
import 'package:thinktank_mobile/widgets/game/user_chip.dart';
import 'package:thinktank_mobile/widgets/others/spinrer.dart';
import 'package:thinktank_mobile/widgets/others/style_button.dart';

class WaitingLobbyScreen extends StatefulWidget {
  const WaitingLobbyScreen({
    super.key,
    required this.room,
  });

  final Room room;

  @override
  State<WaitingLobbyScreen> createState() => _WaitingLobbyScreenState();
}

class _WaitingLobbyScreenState extends State<WaitingLobbyScreen> {
  bool? isOwner;
  late Future _initData;
  Account? account;
  DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  List<AccountInRoom> listMembers = [];
  Future<bool> getData() async {
    account = await SharedPreferencesHelper.getInfo();
    for (AccountInRoom _account in widget.room.accountInRoomResponses) {
      if (account!.id == _account.accountId) {
        return _account.isAdmin;
      }
    }

    return false;
  }

  @override
  void initState() {
    super.initState();

    _initData = getData();
    _initData.then((value) {
      _databaseReference
          .child('room')
          .child(widget.room.code)
          .onValue
          .listen((event) {
        listMembers.clear();
        for (int i = 1; i < 6; i++) {
          if (event.snapshot.hasChild('us$i') &&
              event.snapshot.child('us$i').child('name').value.toString() !=
                  account!.userName) {
            AccountInRoom accountInRoom = AccountInRoom(
                id: i,
                isAdmin: false,
                accountId: 0,
                username:
                    event.snapshot.child('us$i').child('name').value.toString(),
                roomId: 0,
                duration: 0,
                mark: 0,
                pieceOfInformation: 0,
                avatar:
                    event.snapshot.child('us$i').child('avt').value.toString());
            listMembers.add(accountInRoom);
          }
        }
        setState(() {
          listMembers;
        });
      });
      setState(() {
        isOwner = value;
        print(isOwner);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: TRoomAppBar(
        preferredHeight: MediaQuery.of(context).size.height * 0.23,
        room: widget.room,
        isOwner: isOwner ?? false,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/pics/menu_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(
                14,
                MediaQuery.of(context).size.height * 0.15,
                14,
                0,
              ),
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Wrap(
                            alignment: WrapAlignment.start,
                            direction: Axis.horizontal,
                            spacing: 15.0,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            runSpacing: 15.0,
                            children: [
                              //usersRoomTest dùng để test UI
                              for (final acc in listMembers)
                                UserChip(accountInRoom: acc),

                              //sử dụng list user có trong Room
                              //for (final acc in widget.room.accountInRoomResponses)
                              //UserChip(accountInRoom: acc),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: Container(
                              width: 100,
                              height: 100,
                              child: const Center(
                                child: CustomLoadingSpinner(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            isOwner == true
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: const EdgeInsets.only(
                        bottom: 35,
                      ),
                      child: SizedBox(
                        height: 80,
                        width: MediaQuery.of(context).size.width - 80,
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(100),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(255, 40, 52, 68),
                                blurRadius: 0,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {},
                            style: button1v1,
                            child: const Text(
                              'START NOW',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'ButtonCustomFont',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
