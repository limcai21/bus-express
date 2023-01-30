import 'package:bus_express/model/global.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'view/home.dart';
import 'view/favourite.dart';
import 'model/constants.dart';
import 'view/search/search.dart';
import 'view/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'view/components/startUpData.dart';
import 'view/search/components/searchFunction.dart';
import 'package:bus_express/model/custom_icons_icons.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:bus_express/view/components/customScaffold.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appName,
      theme: ThemeData(
        primaryColor: primaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BusArrivalApp(),
    );
  }
}

class BusArrivalApp extends StatefulWidget {
  @override
  State<BusArrivalApp> createState() => BusArrivalAppState();
}

class BusArrivalAppState extends State<BusArrivalApp> {
  int selectedIndex = 0;
  bool doneLoading = false;

  List pagesData = [
    [
      "Home",
      FluentIcons.home_24_regular,
      FluentIcons.home_24_filled,
      Home(),
      Colors.blue,
    ],
    [
      "Search",
      FluentIcons.search_24_regular,
      FluentIcons.search_24_filled,
      Search(),
      Colors.orange,
    ],
    [
      "Favourite",
      FluentIcons.heart_24_regular,
      FluentIcons.heart_24_filled,
      Favourite(),
      Colors.pink,
    ],
    [
      "Profile",
      FluentIcons.person_24_regular,
      FluentIcons.person_24_filled,
      Profile(),
      Colors.teal,
    ],
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  initFunction() async {
    await startUpLoadData(context);

    // CHECK IF USER IS LOGIN
    final prefs = await SharedPreferences.getInstance();
    String checkIfGotLoginPreviously = prefs.getString("loginUser");

    setState(() {
      if (checkIfGotLoginPreviously != null) {
        currentLoginUsername = checkIfGotLoginPreviously;
        isUserLogin = true;
      } else {
        currentLoginUsername = '';
      }
      doneLoading = true;
    });
  }

  @override
  void initState() {
    super.initState();
    initFunction();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      pagesData[selectedIndex][0],
      "",
      doneLoading ? pagesData[selectedIndex][3] : Container(),
      2,
      // backgroundColor: pagesData[selectedIndex][4],
      actionBtn: [
        if (selectedIndex == 1)
          IconButton(
            icon: Icon(CustomIcons.search_regular),
            onPressed: () async {
              await showSearch(
                context: context,
                delegate: DataSearch(),
              );
            },
          ),
      ],
      // bottomNavigationbar: BottomNavigationBar(
      //   type: BottomNavigationBarType.fixed,
      //   // FOR BLUE BACKGROUND
      //   // backgroundColor: Theme.of(context).primaryColor,
      //   // selectedIconTheme: IconThemeData(color: Colors.white),
      //   // unselectedIconTheme: IconThemeData(color: Colors.grey[300]),
      //   // selectedLabelStyle: TextStyle(color: Theme.of(context).primaryColor),
      //   // selectedItemColor: Colors.white,
      //   // showSelectedLabels: false,
      //   // showUnselectedLabels: false,

      //   // FOR WHITE BACKGROUND
      //   backgroundColor: Color.fromRGBO(240, 240, 240, 1),
      //   selectedIconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      //   unselectedIconTheme: IconThemeData(color: Colors.grey),
      //   selectedFontSize: 12,
      //   showSelectedLabels: false,
      //   showUnselectedLabels: false,
      //   items: [
      //     for (var i = 0; i < pagesData.length; i++)
      //       BottomNavigationBarItem(
      //         label: pagesData[i][0],
      //         icon: Icon(pagesData[i][1]),
      //         activeIcon: Icon(pagesData[i][2]),
      //         backgroundColor: Theme.of(context).primaryColor,
      //       ),
      //   ],
      //   currentIndex: selectedIndex,
      //   onTap: onItemTapped,
      // ),

      bottomNavigationbar: Container(
        color: Color.fromRGBO(240, 240, 240, 1),
        child: SalomonBottomBar(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          itemPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          selectedItemColor: Theme.of(context).primaryColor,
          selectedColorOpacity: 0.15,
          // unselectedItemColor: Colors.grey,
          currentIndex: selectedIndex,
          onTap: onItemTapped,
          items: [
            for (var i = 0; i < pagesData.length; i++)
              SalomonBottomBarItem(
                icon: Icon(pagesData[i][1]),
                activeIcon: Icon(pagesData[i][2]),
                title: Text(pagesData[i][0]),
                // selectedColor: pagesData[i][4],
              ),
          ],
        ),
      ),
    );
  }
}
