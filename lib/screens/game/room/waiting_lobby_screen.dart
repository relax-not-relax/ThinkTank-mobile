import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/account_in_room.dart';
import 'package:thinktank_mobile/models/room.dart';
import 'package:thinktank_mobile/widgets/appbar/room_appbar.dart';

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

  Future<bool> getData() async {
    Account? account;
    account = await SharedPreferencesHelper.getInfo();
    for (AccountInRoom _account in widget.room.accountIn1Vs1Responses) {
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
    );
  }
}
