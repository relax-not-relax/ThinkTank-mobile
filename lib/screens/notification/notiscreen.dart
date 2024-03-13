import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:thinktank_mobile/api/notification_api.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/notification_item.dart';
import 'package:thinktank_mobile/widgets/others/noti_element.dart';
import 'package:thinktank_mobile/widgets/others/spinrer.dart';

class NotiScreen extends StatefulWidget {
  const NotiScreen({super.key});

  @override
  State<NotiScreen> createState() => _NotiScreenState();
}

class _NotiScreenState extends State<NotiScreen> {
  List<NotificationItem> notifications = [];
  List<NotificationItem> pushNewNotifications = [];
  bool _isLoaded = true;

  @override
  void initState() {
    super.initState();
    loadingNotifications();
  }

  void loadingNotifications() async {
    setState(() {
      _isLoaded = false;
    });
    // notifications = await SharedPreferencesHelper.getNotifications();
    // if (notifications.isEmpty) {
    //   notifications = await ApiNotification.getNotifications(
    //       loginInfo!.id, loginInfo!.accessToken!);
    //   await SharedPreferencesHelper.saveNotifications(notifications);
    // }
    Account? loginInfo;
    loginInfo = await SharedPreferencesHelper.getInfo();
    notifications = await ApiNotification.getNotifications(
        loginInfo!.id, loginInfo.accessToken!);
    await SharedPreferencesHelper.saveNotifications(notifications);
    setState(() {
      _isLoaded = true;
      notifications;
    });
  }

  void handleReadNotification() async {
    Account? loginInfo;
    loginInfo = await SharedPreferencesHelper.getInfo();
    List<NotificationItem> updatedList = await ApiNotification.getNotifications(
        loginInfo!.id, loginInfo!.accessToken!);
    await SharedPreferencesHelper.saveNotifications(updatedList);
  }

  Future<void> refreshNotifications() async {
    setState(() {
      _isLoaded = false;
    });
    Account? loginInfo;
    loginInfo = await SharedPreferencesHelper.getInfo();
    List<NotificationItem> updatedList = await ApiNotification.getNotifications(
        loginInfo!.id, loginInfo.accessToken!);
    await SharedPreferencesHelper.saveNotifications(updatedList);
    notifications = await SharedPreferencesHelper.getNotifications();
    setState(() {
      notifications;
      _isLoaded = true;
    });
  }

  Future<void> markAllAsRead(List<NotificationItem> inputNotifications) async {
    _closeDialog(context);
    setState(() {
      _isLoaded = false;
    });
    inputNotifications = await SharedPreferencesHelper.getNotifications();

    if (inputNotifications.isNotEmpty) {
      Account? loginInfo;
      loginInfo = await SharedPreferencesHelper.getInfo();

      for (NotificationItem item in inputNotifications) {
        if (item.status == false) {
          await ApiNotification.updateStatusNotification(
              item.id!, loginInfo!.accessToken!);
        }
      }

      List<NotificationItem> updatedList =
          await ApiNotification.getNotifications(
              loginInfo!.id, loginInfo.accessToken!);
      await SharedPreferencesHelper.saveNotifications(updatedList);
      notifications = await SharedPreferencesHelper.getNotifications();
    }

    setState(() {
      _isLoaded = true;
      notifications;
    });
  }

  Future<void> deleteAllNotifications(
      List<NotificationItem> inputNotifications) async {
    _closeDialog(context);
    setState(() {
      _isLoaded = false;
    });
    inputNotifications = await SharedPreferencesHelper.getNotifications();

    if (inputNotifications.isNotEmpty) {
      Account? loginInfo;
      loginInfo = await SharedPreferencesHelper.getInfo();

      List<int> notiIds = [];
      for (NotificationItem item in inputNotifications) {
        notiIds.add(item.id!);
      }

      setState(() {
        notiIds;
      });

      await ApiNotification.deleteAllNotifications(
          notiIds, loginInfo!.accessToken!);
      List<NotificationItem> updatedList =
          await ApiNotification.getNotifications(
              loginInfo!.id, loginInfo.accessToken!);
      await SharedPreferencesHelper.saveNotifications(updatedList);
      notifications = await SharedPreferencesHelper.getNotifications();
    }

    setState(() {
      _isLoaded = true;
      notifications;
    });
  }

  Widget buildNotificationList() {
    return _isLoaded
        ? notifications.isEmpty
            ? RefreshIndicator(
                onRefresh: refreshNotifications,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Center(
                        child: Text(
                          "No notifications found",
                          style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : RefreshIndicator(
                onRefresh: refreshNotifications,
                child: ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) => NotificationElement(
                    notiEl: notifications.reversed.toList()[index],
                    handleReadNotification: handleReadNotification,
                  ),
                ),
              )
        : const Center(child: CustomLoadingSpinner());
  }

  @override
  Widget build(BuildContext context) {
    Future displayBottomSheet(BuildContext context) {
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
                  markAllAsRead(pushNewNotifications);
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
                        IconlyBold.message,
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
              const SizedBox(
                height: 15.0,
              ),
              InkWell(
                onTap: () {
                  deleteAllNotifications(pushNewNotifications);
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
                        IconlyBold.close_square,
                        color: Color.fromARGB(255, 45, 64, 89),
                        size: 30.0,
                      ),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    Text(
                      "Delete All",
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
              "Notification",
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
                  displayBottomSheet(context);
                },
                icon: const Icon(
                  IconlyBold.setting,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      body: buildNotificationList(),
    );
  }
}

void _closeDialog(BuildContext context) {
  Navigator.of(context).pop();
}
