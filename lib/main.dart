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
    ["Home", Icons.home, Home()],
    ["Search", Icons.search_rounded, Search()],
    ["Favourites", Icons.favorite_rounded, Favourite()],
    ["Profile", Icons.person_rounded, Profile()],
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
      // drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text(pagesData[selectedIndex][0]),
        actions: [
          if (selectedIndex == 1)
            IconButton(
              icon: Icon(Icons.search_rounded),
              onPressed: () => showSearch(
                context: context,
                delegate: DataSearch(),
              ),
            ),
        ],
      ),
      body: pagesData[selectedIndex][2],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).primaryColor,
        selectedIconTheme: IconThemeData(color: Colors.white),
        unselectedIconTheme: IconThemeData(color: Colors.grey[300]),
        selectedLabelStyle: TextStyle(color: Theme.of(context).primaryColor),
        selectedItemColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          for (var i = 0; i < pagesData.length; i++)
            BottomNavigationBarItem(
              label: pagesData[i][0],
              icon: Icon(pagesData[i][1]),
              backgroundColor: Theme.of(context).primaryColor,
            ),
        ],
        currentIndex: selectedIndex,
        onTap: onItemTapped,
      ),
    );
  }
}
