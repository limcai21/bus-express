import 'view/home.dart';
import 'model/global.dart';
import 'view/favourite.dart';
import 'model/constants.dart';
import 'view/search/search.dart';
import 'view/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'view/components/startUpData.dart';
import 'view/search/components/searchFunction.dart';
import 'package:bus_express/model/custom_icons_icons.dart';
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
  List pagesData = [
    [
      "Home",
      CustomIcons.home_regular,
      CustomIcons.home_filled,
      Home(),
    ],
    [
      "Search",
      CustomIcons.search_regular,
      CustomIcons.search_filled,
      Search(),
    ],
    [
      "Favourites",
      CustomIcons.favourite_regular,
      CustomIcons.favourite_filled,
      Favourite(),
    ],
    [
      "Profile",
      CustomIcons.profile_regular,
      CustomIcons.profile_filled,
      Profile(),
    ],
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    startUpLoadData(context);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      pagesData[selectedIndex][0],
      "",
      pagesData[selectedIndex][3],
      2,
      actionBtn: [
        if (selectedIndex == 1)
          IconButton(
            icon: Icon(CustomIcons.search_regular),
            onPressed: () async {
              final result = await showSearch(
                context: context,
                delegate: DataSearch(),
              );
              setState(() {
                searchTabIndex = int.parse(result);
              });
            },
          ),
      ],
      bottomNavigationbar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        // FOR BLUE BACKGROUND
        // backgroundColor: Theme.of(context).primaryColor,
        // selectedIconTheme: IconThemeData(color: Colors.white),
        // unselectedIconTheme: IconThemeData(color: Colors.grey[300]),
        // selectedLabelStyle: TextStyle(color: Theme.of(context).primaryColor),
        // selectedItemColor: Colors.white,
        // showSelectedLabels: false,
        // showUnselectedLabels: false,

        // FOR WHITE BACKGROUND
        backgroundColor: Color.fromRGBO(240, 240, 240, 1),
        selectedIconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        unselectedIconTheme: IconThemeData(color: Colors.grey),
        selectedFontSize: 12,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          for (var i = 0; i < pagesData.length; i++)
            BottomNavigationBarItem(
              label: pagesData[i][0],
              icon: Icon(pagesData[i][1]),
              activeIcon: Icon(pagesData[i][2]),
              backgroundColor: Theme.of(context).primaryColor,
            ),
        ],
        currentIndex: selectedIndex,
        onTap: onItemTapped,
      ),
    );
  }
}
