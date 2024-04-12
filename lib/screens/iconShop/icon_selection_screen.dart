import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thinktank_mobile/api/icon_api.dart';
import 'package:thinktank_mobile/models/icon.dart';
import 'package:thinktank_mobile/models/icon_of_server.dart';
import 'package:thinktank_mobile/widgets/others/icon_shop_item.dart';
import 'package:thinktank_mobile/widgets/others/spinrer.dart';

class IconSelectionScreen extends StatefulWidget {
  const IconSelectionScreen({
    super.key,
    required this.setCoins,
  });

  final void Function(int amount) setCoins;

  @override
  State<IconSelectionScreen> createState() => _IconSelectionScreenState();
}

class _IconSelectionScreenState extends State<IconSelectionScreen> {
  bool isLoading = true;
  List<IconServer> iconsOfShop = [];

  late Future<dynamic> _initIcons;

  Future<dynamic> getIconsOfShop() async {
    dynamic result = await ApiIcon.getAllIcons();
    if (result is List<IconServer>) {
      return result;
    } else {
      // ignore: use_build_context_synchronously
      _showResizableDialogError(context, result);
    }
  }

  @override
  void initState() {
    super.initState();
    _initIcons = getIconsOfShop();
    _initIcons.then((value) {
      setState(() {
        isLoading = false;
        iconsOfShop = value;
        print(iconsOfShop);
      });
    });
  }

  Future<void> buy(IconServer icon) async {
    _showResizableDialog(context, icon.avatar, icon.name);
    dynamic result = await ApiIcon.buyIcon(icon.id);
    if (result is IconApp) {
      // ignore: use_build_context_synchronously
      _closeDialog(context);
      widget.setCoins(icon.price);

      // ignore: use_build_context_synchronously
      _showResizableDialogSuccess(context, result);

      Future.delayed(const Duration(seconds: 2), () async {
        // ignore: use_build_context_synchronously
        _closeDialog(context);
        setState(() {
          isLoading = true;
        });
        _initIcons = getIconsOfShop();
        _initIcons.then((value) {
          setState(() {
            isLoading = false;
            iconsOfShop = value;
            print(iconsOfShop);
          });
        });
        // setState(() {
        //   isLoading = false;
        // });
      });
    } else {
      // ignore: use_build_context_synchronously
      _closeDialog(context);
      Future.delayed(const Duration(seconds: 0), () {
        // ignore: use_build_context_synchronously
        _showResizableDialogError(context, result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading || iconsOfShop.isEmpty
        ? Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: CustomLoadingSpinner(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          )
        : Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 20,
            ),
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 10,
              childAspectRatio: 0.75,
              children: iconsOfShop.map((iconData) {
                return IconShopItem(
                  icon: iconData,
                  buyIcon: () async {
                    _showConfirmDialog(
                      context,
                      () {
                        buy(iconData);
                      },
                      iconData.name,
                    );
                  },
                );
              }).toList(),
            ),
          );
  }
}

void _showConfirmDialog(BuildContext context, Function accept, String sticker) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          'Confirmation',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure to buy sticker "$sticker"?',
          style: GoogleFonts.roboto(
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text(
              'No',
              style: TextStyle(
                color: Color.fromARGB(255, 72, 145, 255),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              _closeDialog(context);
              accept();
            },
            child: const Text(
              'Yes',
              style: TextStyle(
                color: Color.fromARGB(255, 72, 145, 255),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      );
    },
  );
}

void _showResizableDialog(BuildContext context, String sticker, String name) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
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
              Image.network(
                sticker,
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
              Text(
                'You are buying sticker "$name"',
                style: const TextStyle(
                    color: Color.fromRGBO(129, 140, 155, 1),
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              const CustomLoadingSpinner(
                  color: Color.fromARGB(255, 245, 149, 24)),
            ],
          ),
        ),
      );
    },
  );
}

void _showResizableDialogSuccess(BuildContext context, IconApp iconBuy) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(0),
        content: Container(
          width: 250,
          height: 300,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Color.fromARGB(255, 249, 249, 249)),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Image.network(
                iconBuy.iconAvatar,
                height: 150,
                width: 150,
              ),
              const SizedBox(height: 10),
              const Text(
                'Successfully bought!',
                style: TextStyle(
                    color: Color.fromRGBO(234, 84, 85, 1),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 5,
                ),
                child: Text(
                  'The sticker "${iconBuy.iconName}" is belong to you.',
                  style: const TextStyle(
                      color: Color.fromRGBO(129, 140, 155, 1),
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void _showResizableDialogError(BuildContext context, String message) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(0),
        content: Container(
          width: 250,
          height: 300,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Color.fromARGB(255, 249, 249, 249)),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Image.asset(
                'assets/pics/error.png',
                height: 150,
                width: 150,
              ),
              const SizedBox(height: 10),
              const Text(
                'Oh no!',
                style: TextStyle(
                    color: Color.fromRGBO(234, 84, 85, 1),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 5,
                ),
                child: Text(
                  message,
                  style: const TextStyle(
                      color: Color.fromRGBO(129, 140, 155, 1),
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void _closeDialog(BuildContext context) {
  Navigator.of(context).pop();
}