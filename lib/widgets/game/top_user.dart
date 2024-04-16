import 'package:flutter/material.dart';
import 'package:thinktank_mobile/controller/network_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thinktank_mobile/widgets/game/coin_div.dart';

class TopUser extends StatelessWidget {
  const TopUser({
    super.key,
    required this.userAva,
    required this.top,
    required this.userName,
    required this.point,
    required this.isBordered,
  });

  final String userAva;
  final String userName;
  final String point;
  final int top;
  final bool isBordered;

  @override
  Widget build(BuildContext context) {
    NetworkManager.currentContext = context;
    final List<Color> topUserColor = [
      const Color.fromARGB(255, 251, 189, 5),
      const Color.fromARGB(255, 149, 149, 149),
      const Color.fromARGB(255, 192, 115, 0),
      const Color.fromARGB(255, 234, 68, 53),
      const Color.fromARGB(255, 45, 64, 89),
    ];

    final List<double> topUserRadius = [
      100,
      80,
      80,
      120,
    ];

    Widget content = Container();

    switch (top) {
      case 1:
        content = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: topUserRadius[0],
              height: topUserRadius[0],
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                //borderRadius: BorderRadius.circular(20.0),
                image: DecorationImage(
                  image: NetworkImage(userAva),
                  fit: BoxFit.contain,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
                border: isBordered == true
                    ? Border.all(
                        color: topUserColor[0],
                        width: 8,
                      )
                    : Border.all(
                        color: Colors.transparent,
                        width: 0,
                      ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              userName,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                shadows: [
                  const Shadow(
                    offset: Offset(0, 5.0),
                    blurRadius: 30.0,
                    color: Color.fromARGB(172, 0, 0, 0),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            Text(
              point,
              style: TextStyle(
                fontFamily: 'CustomProFont',
                fontSize: 18,
                color: topUserColor[3],
                shadows: const [
                  Shadow(
                    offset: Offset(0, 5.0),
                    blurRadius: 30.0,
                    color: Color.fromARGB(52, 0, 0, 0),
                  ),
                ],
              ),
            ),
          ],
        );
        break;
      case 2:
        content = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: topUserRadius[1],
              height: topUserRadius[1],
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                //borderRadius: BorderRadius.circular(20.0),
                image: DecorationImage(
                  image: NetworkImage(userAva),
                  fit: BoxFit.contain,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
                border: isBordered == true
                    ? Border.all(
                        color: topUserColor[1],
                        width: 8,
                      )
                    : Border.all(
                        color: Colors.transparent,
                        width: 0,
                      ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              userName,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                shadows: [
                  const Shadow(
                    offset: Offset(0, 5.0),
                    blurRadius: 30.0,
                    color: Color.fromARGB(172, 0, 0, 0),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            Text(
              point,
              style: TextStyle(
                fontFamily: 'CustomProFont',
                fontSize: 18,
                color: topUserColor[4],
                shadows: const [
                  Shadow(
                    offset: Offset(0, 5.0),
                    blurRadius: 30.0,
                    color: Color.fromARGB(52, 0, 0, 0),
                  ),
                ],
              ),
            ),
          ],
        );
        break;
      case 3:
        content = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: topUserRadius[2],
              height: topUserRadius[2],
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                //borderRadius: BorderRadius.circular(20.0),
                image: DecorationImage(
                  image: NetworkImage(userAva),
                  fit: BoxFit.contain,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
                border: isBordered == true
                    ? Border.all(
                        color: topUserColor[2],
                        width: 8,
                      )
                    : Border.all(
                        color: Colors.transparent,
                        width: 0,
                      ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              userName,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                shadows: [
                  const Shadow(
                    offset: Offset(0, 5.0),
                    blurRadius: 30.0,
                    color: Color.fromARGB(172, 0, 0, 0),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            Text(
              point,
              style: TextStyle(
                fontFamily: 'CustomProFont',
                fontSize: 18,
                color: topUserColor[4],
                shadows: const [
                  Shadow(
                    offset: Offset(0, 5.0),
                    blurRadius: 30.0,
                    color: Color.fromARGB(52, 0, 0, 0),
                  ),
                ],
              ),
            ),
          ],
        );
        break;
      case 4:
        content = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: topUserRadius[3],
              height: topUserRadius[3],
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                //borderRadius: BorderRadius.circular(20.0),
                image: DecorationImage(
                  image: NetworkImage(userAva),
                  fit: BoxFit.contain,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
                border: isBordered == true
                    ? Border.all(
                        color: topUserColor[0],
                        width: 8,
                      )
                    : Border.all(
                        color: Colors.transparent,
                        width: 0,
                      ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              userName,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                shadows: [
                  const Shadow(
                    offset: Offset(0, 5.0),
                    blurRadius: 30.0,
                    color: Color.fromARGB(172, 0, 0, 0),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            Text(
              point,
              style: TextStyle(
                fontFamily: 'CustomProFont',
                fontSize: 20,
                color: topUserColor[4],
                shadows: const [
                  Shadow(
                    offset: Offset(0, 5.0),
                    blurRadius: 30.0,
                    color: Color.fromARGB(52, 0, 0, 0),
                  ),
                ],
              ),
            ),
          ],
        );
        break;
      case 5:
        content = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Container(
                  width: topUserRadius[3],
                  height: topUserRadius[3],
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    //borderRadius: BorderRadius.circular(20.0),
                    image: DecorationImage(
                      image: NetworkImage(userAva),
                      fit: BoxFit.contain,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                    border: isBordered == true
                        ? Border.all(
                            color: topUserColor[0],
                            width: 8,
                          )
                        : Border.all(
                            color: Colors.transparent,
                            width: 0,
                          ),
                  ),
                ),
                Container(
                  width: topUserRadius[3],
                  height: topUserRadius[3],
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    //borderRadius: BorderRadius.circular(20.0),
                    color: Color.fromARGB(139, 17, 17, 17),
                  ),
                ),
                Container(
                  width: topUserRadius[3],
                  height: topUserRadius[3],
                  child: const Center(
                    child: CoinDiv(
                      amount: "20",
                      color: Colors.white,
                      size: 30,
                      textSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              userName,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                shadows: [
                  const Shadow(
                    offset: Offset(0, 5.0),
                    blurRadius: 30.0,
                    color: Color.fromARGB(172, 0, 0, 0),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            Text(
              point,
              style: TextStyle(
                fontFamily: 'CustomProFont',
                fontSize: 20,
                color: topUserColor[0],
                shadows: const [
                  Shadow(
                    offset: Offset(0, 5.0),
                    blurRadius: 30.0,
                    color: Color.fromARGB(52, 0, 0, 0),
                  ),
                ],
              ),
            ),
          ],
        );
        break;
      case 6:
        content = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Container(
                  width: topUserRadius[3],
                  height: topUserRadius[3],
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    //borderRadius: BorderRadius.circular(20.0),
                    image: DecorationImage(
                      image: NetworkImage(userAva),
                      fit: BoxFit.contain,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                    border: isBordered == true
                        ? Border.all(
                            color: topUserColor[0],
                            width: 8,
                          )
                        : Border.all(
                            color: Colors.transparent,
                            width: 0,
                          ),
                  ),
                ),
                Container(
                  width: topUserRadius[3],
                  height: topUserRadius[3],
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    //borderRadius: BorderRadius.circular(20.0),
                    color: Color.fromARGB(139, 17, 17, 17),
                  ),
                ),
                Container(
                  width: topUserRadius[3],
                  height: topUserRadius[3],
                  child: const Center(
                    child: CoinDiv(
                      amount: "20",
                      color: Colors.white,
                      size: 30,
                      textSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              userName,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                shadows: [
                  const Shadow(
                    offset: Offset(0, 5.0),
                    blurRadius: 30.0,
                    color: Color.fromARGB(172, 0, 0, 0),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            Text(
              point,
              style: TextStyle(
                fontFamily: 'CustomProFont',
                fontSize: 20,
                color: topUserColor[4],
                shadows: const [
                  Shadow(
                    offset: Offset(0, 5.0),
                    blurRadius: 30.0,
                    color: Color.fromARGB(52, 0, 0, 0),
                  ),
                ],
              ),
            ),
          ],
        );
        break;
    }

    return content;
  }
}
