import 'package:flutter/material.dart';
import 'package:thinktank_mobile/controller/network_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:thinktank_mobile/api/account_api.dart';

import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';

import 'package:thinktank_mobile/screens/iconShop/icon_selection_screen.dart';
import 'package:thinktank_mobile/screens/iconShop/own_icon_screen.dart';
import 'package:thinktank_mobile/widgets/appbar/shop_appbar.dart';

class IconShopScreen extends StatefulWidget {
  const IconShopScreen({super.key});

  @override
  State<IconShopScreen> createState() => _IconShopScreenState();
}

class _IconShopScreenState extends State<IconShopScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Account? account = null;
  late Future _initAccount;
  int amountOfCoins = 0;

  Future<dynamic> getAccount() async {
    dynamic result = await ApiAccount.getAccountById();
    if (result is Account) {
      return result;
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _initAccount = getAccount();
    _initAccount.then((value) {
      setState(() {
        account = value;
        amountOfCoins = account!.coin!;
      });
    });
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        // Forces widget to rebuild when tab changes
      });
    }
  }

  void updateTotal(int coinAmount) {
    setState(() {
      amountOfCoins = amountOfCoins - coinAmount;
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    NetworkManager.currentContext = context;
    Color getColor(bool isSelected) => isSelected ? Colors.white : Colors.grey;

    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: account == null
          ? TShopAppBar(
              preferredHeight: MediaQuery.of(context).size.height * 0.35,
              coins: "0",
            )
          : TShopAppBar(
              preferredHeight: MediaQuery.of(context).size.height * 0.35,
              coins: "$amountOfCoins",
            ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.65,
        child: Column(
          children: [
            Container(
              child: TabBar(
                controller: _tabController,
                indicatorColor: Colors.white,
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          IconlyBold.ticket_star,
                          color: getColor(_tabController.index == 0),
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        Text(
                          "Shop",
                          style: GoogleFonts.inter(
                            color: getColor(_tabController.index == 0),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          IconlyBold.game,
                          color: getColor(_tabController.index == 1),
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        Text(
                          "Own",
                          style: GoogleFonts.inter(
                            color: getColor(_tabController.index == 1),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  IconSelectionScreen(
                    setCoins: updateTotal,
                  ),
                  OwnIconScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
