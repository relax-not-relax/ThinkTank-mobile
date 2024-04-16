import 'dart:io';

import 'package:flutter/material.dart';
import 'package:thinktank_mobile/controller/network_manager.dart';

class WalkThroughItem extends StatelessWidget {
  const WalkThroughItem({
    super.key,
    required this.imgPath,
    required this.onSelect,
    required this.itemIndex,
    required this.isBattle,
  });

  final String imgPath;
  final void Function() onSelect;
  final int itemIndex;
  final bool isBattle;

  @override
  Widget build(BuildContext context) {
    NetworkManager.currentContext = context;
    Color _boxColor = Colors.black;

    switch (itemIndex) {
      case 0:
        _boxColor = const Color.fromARGB(255, 103, 152, 215);
        break;
      case 1:
        _boxColor = const Color.fromARGB(255, 251, 124, 5);
        break;
      case 2:
        _boxColor = const Color.fromARGB(255, 255, 213, 0);
        break;
      case 3:
        _boxColor = const Color.fromARGB(255, 206, 101, 255);
        break;
    }

    return InkWell(
      onTap: () {
        onSelect();
      },
      child: Container(
        //padding: const EdgeInsets.all(30.0),
        decoration: BoxDecoration(
          color: _boxColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        child: isBattle
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 80.0,
                      height: 80.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          // image: AssetImage(imgPath),
                          image: FileImage(File(imgPath)),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          // image: AssetImage(imgPath),
                          image: FileImage(File(imgPath)),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
