import 'package:flutter/material.dart'
    show
        BorderRadius,
        ButtonStyle,
        Color,
        Colors,
        ElevatedButton,
        Radius,
        RoundedRectangleBorder,
        Size;
import 'package:flutter/widgets.dart';

final ButtonStyle buttonPrimary = ElevatedButton.styleFrom(
  minimumSize: const Size(380, 70),
  backgroundColor: const Color.fromRGBO(240, 123, 63, 1),
  elevation: 0,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(10),
    ),
  ),
);
final ButtonStyle buttonPrimaryPink = ElevatedButton.styleFrom(
  minimumSize: const Size(350, 70),
  backgroundColor: const Color.fromRGBO(234, 84, 85, 1),
  elevation: 0,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(10),
    ),
  ),
);
final ButtonStyle buttonSecondary = ElevatedButton.styleFrom(
  minimumSize: const Size(380, 70),
  backgroundColor: Color.fromARGB(0, 240, 122, 63),
  elevation: 0,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(10),
    ),
    side: BorderSide(
      color: const Color.fromRGBO(240, 123, 63, 1),
      width: 2.0,
    ),
  ),
);
final ButtonStyle buttonGoogle = ElevatedButton.styleFrom(
  minimumSize: const Size(380, 70),
  backgroundColor: Color.fromARGB(255, 255, 255, 255),
  elevation: 1,
  shadowColor: Colors.amber,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(10),
    ),
  ),
);

final ButtonStyle buttonPlay = ElevatedButton.styleFrom(
  backgroundColor: const Color.fromRGBO(234, 67, 53, 1),
  elevation: 0,
  shape: const RoundedRectangleBorder(
    side: BorderSide(
      color: Colors.white,
      width: 3.8,
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(100),
    ),
  ),
);
final ButtonStyle button1v1 = ElevatedButton.styleFrom(
  backgroundColor: const Color.fromRGBO(240, 123, 63, 1),
  elevation: 0,
  shape: const RoundedRectangleBorder(
    side: BorderSide(
      color: Colors.white,
      width: 3.8,
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(100),
    ),
  ),
);
final ButtonStyle buttonWin = ElevatedButton.styleFrom(
  backgroundColor: const Color.fromRGBO(255, 212, 96, 1),
  elevation: 0,
  shape: const RoundedRectangleBorder(
    side: BorderSide(
      color: Colors.white,
      width: 3.8,
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(100),
    ),
  ),
);

final ButtonStyle buttonLose = ElevatedButton.styleFrom(
  backgroundColor: const Color.fromRGBO(45, 64, 89, 1),
  elevation: 0,
  shape: const RoundedRectangleBorder(
    side: BorderSide(
      color: Colors.white,
      width: 3.8,
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(100),
    ),
  ),
);

final ButtonStyle buttonPass = ElevatedButton.styleFrom(
  backgroundColor: Color.fromARGB(0, 240, 122, 63),
  elevation: 8,
  shape: const RoundedRectangleBorder(
    side: BorderSide(
      color: Color.fromRGBO(234, 84, 85, 1),
      width: 5,
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(100),
    ),
  ),
);

final ButtonStyle buttonLeaderboard = ElevatedButton.styleFrom(
  backgroundColor: Color.fromARGB(0, 255, 255, 255),
  elevation: 0,
  shape: const RoundedRectangleBorder(
    side: BorderSide(
      color: Color.fromRGBO(234, 84, 85, 1),
      width: 3.8,
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(100),
    ),
  ),
);

ButtonStyle buttonLevel(BuildContext context) {
  return ElevatedButton.styleFrom(
    fixedSize: Size(MediaQuery.of(context).size.width - 100, 70.0),
    backgroundColor: const Color.fromARGB(129, 211, 211, 211),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(50),
      ),
    ),
  );
}

ButtonStyle buttonYesBottomSheet(BuildContext context) {
  return ElevatedButton.styleFrom(
    fixedSize: Size(MediaQuery.of(context).size.width - 100, 70.0),
    backgroundColor: const Color.fromARGB(255, 103, 152, 215),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(50),
      ),
      side: BorderSide(
        color: Color.fromARGB(255, 255, 255, 255),
        width: 4,
      ),
    ),
  );
}

ButtonStyle buttonLevelCompleted(BuildContext context) {
  return ElevatedButton.styleFrom(
    fixedSize: Size(MediaQuery.of(context).size.width - 100, 70.0),
    backgroundColor: const Color.fromARGB(255, 255, 212, 96),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(50),
      ),
      side: BorderSide(
        color: Colors.white,
        width: 4,
      ),
    ),
  );
}
