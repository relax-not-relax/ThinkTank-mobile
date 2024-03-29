import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:thinktank_mobile/api/notification_api.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/notification_item.dart';

class NotificationElement extends StatefulWidget {
  const NotificationElement({
    super.key,
    required this.notiEl,
    required this.handleReadNotification,
  });

  final NotificationItem notiEl;
  final Function() handleReadNotification;

  @override
  State<NotificationElement> createState() => _NotificationElementState();
}

class _NotificationElementState extends State<NotificationElement> {
  late String parsedDate;
  late DateTime formatDate;

  late bool _isRead;

  @override
  void initState() {
    super.initState();
    formatDate = DateTime.parse(widget.notiEl.dateTime!);
    parsedDate = DateFormat('MMM dd, yyyy').format(formatDate);
    _isRead = widget.notiEl.status!;
  }

  void readNotification() async {
    Account? loginInfo = await SharedPreferencesHelper.getInfo();

    await ApiNotification.updateStatusNotification(
        widget.notiEl.id!, loginInfo!.accessToken!);

    if (_isRead == false) {
      setState(() {
        _isRead = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 15.0,
        ),
        GestureDetector(
          onTap: () {
            readNotification();
            widget.handleReadNotification();
          },
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 14.0,
            ),
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(10.0),
              ),
              color: _isRead == false
                  ? const Color.fromARGB(255, 44, 44, 44)
                  : Color.fromARGB(255, 22, 22, 22),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 25.0,
                      backgroundImage: NetworkImage(widget.notiEl.avatar!),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(
                          left: 20.0,
                          right: 10.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.notiEl.title!,
                              style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 16.0,
                              ),
                            ),
                            Text(
                              widget.notiEl.description!,
                              style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: 14.0,
                              ),
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            Text(
                              parsedDate,
                              style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    _isRead == false
                        ? const CircleAvatar(
                            backgroundColor: Color.fromARGB(255, 240, 122, 63),
                            radius: 7.0,
                          )
                        : const CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 7.0,
                          ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
