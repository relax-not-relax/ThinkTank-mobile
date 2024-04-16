import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:thinktank_mobile/controller/network_manager.dart';
import 'package:flutter/services.dart';
import 'package:thinktank_mobile/widgets/others/spinrer.dart';
import 'package:thinktank_mobile/widgets/others/style_button.dart';

class NetworkManager {
  static final Connectivity _connectivity = Connectivity();
  static BuildContext? currentContext;
  static late StreamSubscription<List<ConnectivityResult>>
      _connectivitySubscription;

  static void init() {
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(updateConnectionStatus);
  }

  static void dispose() {
    _connectivitySubscription.cancel();
  }

  static void updateConnectionStatus(List<ConnectivityResult> result) {
    if (result[0].toString() == "ConnectivityResult.none") {
      print("Network Error");
      _showResizableDialog(currentContext!);
      // if (currentContext != null) {
      //   _showResizableDialog(currentContext!);
      // }
    } else {
      print("Da ket noi");
    }
  }

  static void _showResizableDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
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
                    'assets/pics/accOragne.png',
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
                  const Text(
                    'Please wait a moment, Logouting...',
                    style: TextStyle(
                        color: Color.fromRGBO(129, 140, 155, 1),
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          SystemNavigator.pop();
                        },
                        style: buttonPrimaryPinkVer2(context),
                        child: const Text(
                          'EXIT',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
