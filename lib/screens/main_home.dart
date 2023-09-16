import 'package:bide/screens/games/history.dart';
import 'package:bide/screens/games/home.dart';
import 'package:bide/screens/games/new.dart';
import 'package:bide/utils/colors.dart';
import 'package:bide/screens/wallet/wallet.dart';
import 'package:bide/screens/user_info.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentTab = 0;
  final List<Widget> screens = [
    GameScreeenFirst(),
    WalletScreen(),
    NewGameScreen(),
    GameHistoryScreen(),
    UserInformationScreen(),
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = GameScreeenFirst();
  bool isFabVisible = true;

  @override
  Widget build(BuildContext context) {
    bool showFab = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      backgroundColor: secondaryColor,
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),
      floatingActionButton: Visibility(
        visible: !showFab,
        child: FloatingActionButton(
            backgroundColor: primaryColor,
            child: Icon(
              Icons.gamepad_outlined,
              color: secondaryColor,
            ),
            onPressed: () {
              setState(() {
                currentScreen = NewGameScreen();
                currentTab = 4;
              });
            }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = GameScreeenFirst();
                        currentTab = 0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.list_alt,
                          color: currentTab == 0 ? primaryColor : Colors.grey,
                        ),
                        Text(
                          "Dashboard",
                          style: TextStyle(
                              color:
                                  currentTab == 0 ? primaryColor : Colors.grey),
                        )
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = WalletScreen();
                        currentTab = 1;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.account_balance_wallet,
                          color: currentTab == 1 ? primaryColor : Colors.grey,
                        ),
                        Text(
                          "Wallet",
                          style: TextStyle(
                              color:
                                  currentTab == 1 ? primaryColor : Colors.grey),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = GameHistoryScreen();
                        currentTab = 2;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history,
                          color: currentTab == 2 ? primaryColor : Colors.grey,
                        ),
                        Text(
                          "History",
                          style: TextStyle(
                              color:
                                  currentTab == 2 ? primaryColor : Colors.grey),
                        )
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = UserInformationScreen();
                        currentTab = 3;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_2_outlined,
                          color: currentTab == 3 ? primaryColor : Colors.grey,
                        ),
                        Text(
                          "Profile",
                          style: TextStyle(
                              color:
                                  currentTab == 3 ? primaryColor : Colors.grey),
                        )
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
