import 'package:flutter/material.dart';
import 'package:thinktank_mobile/widgets/others/spinrer.dart';

class LoadingCustom {
  static void loaded(BuildContext context) async {
    Navigator.of(context).pop();
  }

  static void loading(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: const EdgeInsets.all(0),
          content: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Color.fromARGB(0, 249, 249, 249)),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomLoadingSpinner(color: Color.fromARGB(255, 245, 149, 24)),
              ],
            ),
          ),
        );
      },
    );
  }
}
