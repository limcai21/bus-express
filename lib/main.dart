import 'package:bus_express/custom_icons_icons.dart';
import 'package:flutter/material.dart';
import 'view/components/startUpData.dart';
import 'view/favourite/favourite.dart';
import 'view/home.dart';
import 'view/search/search.dart';
import 'view/profile/profile.dart';
import 'model/constants.dart';
import 'view/search/components/searchFunction.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(pagesData[selectedIndex][0]),
        actions: [
          if (selectedIndex == 1)
            IconButton(
              icon: Icon(CustomIcons.search_regular),
              onPressed: () => showSearch(
                context: context,
                delegate: DataSearch(),
              ),
            ),
        ],
      ),
      body: pagesData[selectedIndex][3],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        // FOR BLUE BACKGROUND
        backgroundColor: Theme.of(context).primaryColor,
        selectedIconTheme: IconThemeData(color: Colors.white),
        unselectedIconTheme: IconThemeData(color: Colors.grey[300]),
        selectedLabelStyle: TextStyle(color: Theme.of(context).primaryColor),
        selectedItemColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,

        // FOR WHITE BACKGROUND
        // selectedIconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        // unselectedIconTheme: IconThemeData(color: Colors.grey),
        // showSelectedLabels: true,
        // showUnselectedLabels: true,
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
