import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thinktank_mobile/api/icon_api.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/icon.dart';
import 'package:thinktank_mobile/widgets/others/spinrer.dart';

class OwnIconScreen extends StatefulWidget {
  const OwnIconScreen({super.key});

  @override
  State<OwnIconScreen> createState() => _OwnIconScreenState();
}

class _OwnIconScreenState extends State<OwnIconScreen> {
  bool isLoading = true;
  List<IconApp> iconsOfAccount = [];

  late Future _initIcons;

  Future<List<IconApp>> getIcons() async {
    await ApiIcon.getIconsOfAccount();
    List<IconApp> icons = await SharedPreferencesHelper.getIconSources();
    return icons;
  }

  @override
  void initState() {
    super.initState();
    _initIcons = getIcons();
    _initIcons.then((value) {
      setState(() {
        isLoading = false;
        iconsOfAccount = value;
        print(iconsOfAccount.length);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading || iconsOfAccount.isEmpty
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
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.6,
              children: iconsOfAccount.map((iconData) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(117, 83, 83, 83),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(iconData.iconAvatar),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: SizedBox(
                          height: 30,
                          width: 120,
                          child: Text(
                            iconData.iconName,
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          );
  }
}
