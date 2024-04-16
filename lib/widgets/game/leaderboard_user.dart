import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:thinktank_mobile/controller/network_manager.dart';
import 'package:google_fonts/google_fonts.dart';

class LeaderBoardUser extends StatelessWidget {
  const LeaderBoardUser({
    super.key,
    required this.position,
    required this.userAva,
    required this.userName,
    required this.point,
  });

  final int position;
  final String userAva;
  final String userName;
  final String point;

  @override
  Widget build(BuildContext context) {
    NetworkManager.currentContext = context;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Text(
                position.toString(),
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  //borderRadius: BorderRadius.circular(20.0),
                  image: DecorationImage(
                    image: NetworkImage(userAva),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 5,
              child: Text(
                userName,
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              flex: 3,
              child: Text(
                point,
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        Container(
          height: 1,
          width: MediaQuery.of(context).size.width,
          color: Color.fromARGB(103, 129, 140, 155),
        ),
      ],
    );
  }
}
