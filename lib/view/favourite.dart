import 'dart:async';
import 'dart:convert';
import 'package:bus_express/view/components/busArrivalData/busArrivalDataLeadingAndTrailing.dart';
import 'package:bus_express/view/components/busArrivalData/busArrivalDataTitleAndBackground.dart';
import 'package:bus_express/view/search/busArrival/busesLocation.dart';
import 'package:flutter/material.dart';
import 'package:bus_express/model/api.dart';
import 'package:bus_express/model/global.dart';
import 'package:bus_express/view/components/alert/alertLoading.dart';
import 'package:bus_express/view/search/busArrival/addingAndRemovingFav.dart';
import 'package:bus_express/view/search/busArrival/busArrival.dart';
import 'package:bus_express/view/search/busRoute/busRoute.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Favourite extends StatefulWidget {
  @override
  State<Favourite> createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  var prefs;
  bool isDataLoaded = false;
  bool stopTimer = false;
  Timer refreshTimer;
  Map<String, dynamic> favListBusArrivalData = {};
  Map<String, dynamic> favListData = {};
  List<Widget> listViewChildren = [];

  notLoginAndNoFavouriteLayout(
      String image, double imageWidth, String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Image.asset(image, width: imageWidth, fit: BoxFit.contain),
              SizedBox(height: 20),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 2),
              Text(subtitle, textAlign: TextAlign.center),
            ],
          ),
        ),
      ],
    );
  }

  // GET ALL DATA
  getUserFavList() async {
    final usernameFavList = currentLoginUsername + "FavList";

    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(usernameFavList);
    if (data != null) {
      final jsonData = jsonDecode(data);

      setState(() {
        favListData = jsonData;
      });
    }
  }

  getUserFavListBusArrivalTime() async {
    for (var buses in favListData.entries) {
      final code = buses.key;
      final List favBuses = buses.value;
      final List busTimingHolder = [];

      for (var i = 0; i < favBuses.length; i++) {
        Map<String, dynamic> temp =
            await Bus().arrival(code, busService: favBuses[i]);
        busTimingHolder.add(temp);
      }

      setState(() {
        favListBusArrivalData[code] = busTimingHolder;
      });
    }
  }

  // FAV LIST VIEW
  busStopHeader(String title, String code, String roadName) {
    return GestureDetector(
      onTap: () {
        setState(() {
          stopTimer = true;
          refreshTimer.cancel();
          print('timer stop at fav');
        });
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return SearchBusArrival(title, code, roadName);
        })).then((value) async {
          setState(() {
            stopTimer = false;
            isDataLoaded = false;
            print("start timer again");
          });

          await pageInitFunction();
        });
      },
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.fromLTRB(20, 40, 20, 10),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border(bottom: BorderSide(width: 0.5, color: Colors.grey)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: Theme.of(context).textTheme.headline6.fontSize,
              ),
            ),
            Text(
              roadName + " • " + code,
              style: TextStyle(color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }

  favListListTile(
      bool gotData, String code, String busService, String busStopName,
      {Map arrivalData}) {
    return Dismissible(
      key: Key(busService),
      background: busArrivalDataBackground(context),
      secondaryBackground: busArrivalDataBackground2(),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20),
        title: busArrivalDataTitle(busService, arrivalData),
        subtitle: gotData
            ? Text(arrivalData['destinationName'])
            : Text(allBusServiceData[busService] != null
                ? allBusServiceData[busService]['operator']
                : ""),
        leading: busArrivalDataLeading(arrivalData),
        trailing: busArrivalDataTrailing(arrivalData, gotData),
        onTap: () {
          if (arrivalData != null) {
            setState(() {
              stopTimer = true;
              refreshTimer.cancel();
              print('timer stop at fav');
            });
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SearchBusRoute(busService)),
            ).then((value) async {
              setState(() {
                stopTimer = false;
                isDataLoaded = false;
                print("start timer again");
              });

              await pageInitFunction();
            });
          }
        },
        onLongPress: () {
          if (arrivalData != null) {
            setState(() {
              stopTimer = true;
              refreshTimer.cancel();
            });
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BusesLocation(
                  busService,
                  arrivalData['destinationName'],
                  arrivalData,
                  code,
                  busStopName,
                ),
              ),
            ).then((value) async {
              // IF USER RETURN TO THIS PAGE
              setState(() {
                stopTimer = false;
                isDataLoaded = false;
                print("start timer again");
              });
              await pageInitFunction();
            });
          }
        },
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          await removeBusServiceFromFav(code, busService);
          setState(() {
            isDataLoaded = false;
            pageInitFunction();
          });
        }

        return false;
      },
    );
  }

  generatorFavListListView() async {
    List<Widget> forListViewChildren = [];

    for (var buses in favListData.entries) {
      final favBuses = buses.value;
      final code = buses.key;
      final title = allBusStopsData[buses.key]['description'];
      final roadName = allBusStopsData[buses.key]['roadName'];

      forListViewChildren.add(busStopHeader(title, code, roadName));

      for (var i = 0; i < favBuses.length; i++) {
        final busService = favBuses[i];
        Map<String, dynamic> temp =
            await Bus().arrival(code, busService: busService);

        if (temp.keys.isEmpty) {
          // NO ARRIVAL DATA
          forListViewChildren
              .add(favListListTile(false, code, busService, title));
        } else {
          // GOT ARRIVAL DATA
          forListViewChildren.add(
            favListListTile(
              true,
              code,
              busService,
              title,
              arrivalData: temp.values.toList()[0],
            ),
          );
        }
      }
    }

    return forListViewChildren;
  }

  // INIT PAGE
  pageInitFunction() async {
    if (isUserLogin && !isDataLoaded) {
      await loadingAlert(context);
      await getUserFavList();
      var temp = await generatorFavListListView();
      await getUserFavListBusArrivalTime();

      if (favListData.isNotEmpty) {
        // REFRESH TIMER EVERY MIN
        if (stopTimer == true) {
          if (refreshTimer != null) {
            refreshTimer.cancel();
          }
        } else {
          if (refreshTimer == null) {
            refreshTimer = new Timer.periodic(
              Duration(seconds: 60),
              (Timer t) {
                setState(() {
                  isDataLoaded = false;
                  pageInitFunction();
                  print('fav refresh list');
                });
              },
            );
          } else if (!refreshTimer.isActive) {
            refreshTimer = new Timer.periodic(
              Duration(seconds: 60),
              (Timer t) {
                setState(() {
                  isDataLoaded = false;
                  pageInitFunction();
                  print('fav refresh list here');
                });
              },
            );
          }
        }
      }

      setState(() {
        if (favListData.isEmpty) {
          favListBusArrivalData = {};
        } else {
          favListBusArrivalData = favListBusArrivalData;
        }
        listViewChildren = temp;
        isDataLoaded = true;
      });

      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    if (currentLoginUsername.isNotEmpty) {
      pageInitFunction();
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (refreshTimer != null) {
      refreshTimer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isUserLogin) {
      if (isDataLoaded) {
        if (favListBusArrivalData != null && favListBusArrivalData.isNotEmpty) {
          return Column(
            children: [
              legendForBus(),
              Expanded(
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: listViewChildren,
                ),
              ),
            ],
          );
        } else {
          return notLoginAndNoFavouriteLayout(
            "images/travelTogether.png",
            275,
            "Favourite",
            "Add your favourite bus stops and travel together",
          );
        }
      } else {
        return notLoginAndNoFavouriteLayout(
          "images/travelTogether.png",
          275,
          "Loading",
          "You will see your favourite bus stops soon",
        );
      }
    } else {
      return notLoginAndNoFavouriteLayout(
        "images/busStop.png",
        600,
        "Loving It?",
        "Login to favourite all your bus stops",
      );
    }
  }
}
