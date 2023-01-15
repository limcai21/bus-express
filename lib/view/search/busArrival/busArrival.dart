import 'dart:async';
import 'dart:convert';
import 'package:bus_express/model/switchCase.dart';
import 'package:bus_express/view/search/busArrival/busesLocation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bus_express/model/api.dart';
import 'package:bus_express/model/constants.dart';
import 'package:bus_express/model/global.dart';
import 'package:bus_express/view/components/alertDialog.dart';
import 'package:bus_express/view/components/loadingAlert.dart';
import 'package:bus_express/view/search/busArrival/addingAndRemovingFav.dart';
import 'package:bus_express/view/search/busRoute/busRoute.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchBusArrival extends StatefulWidget {
  String title;
  String busStopCode;
  String roadName;
  SearchBusArrival(this.title, this.busStopCode, this.roadName);

  @override
  State<SearchBusArrival> createState() => _SearchBusArrivalState();
}

class _SearchBusArrivalState extends State<SearchBusArrival> {
  var prefs;
  Timer refreshTimer;
  MapController mapController;
  bool isDataLoaded = false;
  bool stopTimer = false;
  bool busInThisBusStopLoadedFinish = false;
  List busInThisBusStop = [];
  List busesInFavList = [];
  Map<String, dynamic> busArrivalData = {};
  final usernameFavList = currentLoginUsername + "FavList";

  loadBusArrivalData(busStopCode) async {
    Map<String, dynamic> temp = await Bus().arrival(busStopCode);
    List temp2 = await Bus().service(busStopCode);

    if (this.mounted == true) {
      setState(() {
        if (temp.isNotEmpty) {
          busArrivalData = temp;
          print('refreshed');
        } else {
          busInThisBusStop = temp2;
          stopTimer = true;
          busInThisBusStopLoadedFinish = true;
          print("no data so show bus in this bus stop");
        }
      });
    }
  }

  checkIfBusServiceIsFavOrNot(String busStopCode) async {
    prefs = await SharedPreferences.getInstance();
    final usernameFavList = currentLoginUsername + "FavList";
    String currentUserFavList = prefs.getString(usernameFavList);
    if (currentUserFavList != null) {
      Map<String, dynamic> decodeJSON = jsonDecode(currentUserFavList);
      if (decodeJSON[busStopCode] != null &&
          decodeJSON[busStopCode].isNotEmpty) {
        setState(() {
          busesInFavList = decodeJSON[busStopCode];
        });
      } else {
        decodeJSON.removeWhere((key, value) => key == busStopCode);
        setState(() {
          busesInFavList = [];
        });
      }
    }
  }

  initPageData(busStopCode) async {
    loadingAlert(context);
    await loadBusArrivalData(busStopCode);
    await checkIfBusServiceIsFavOrNot(busStopCode);
    setState(() {
      isDataLoaded = true;
    });

    if (stopTimer == true) {
      if (refreshTimer != null) {
        refreshTimer.cancel();
      }
    } else {
      if (refreshTimer == null) {
        refreshTimer = Timer.periodic(
          Duration(seconds: 60),
          (Timer t) => initPageData(widget.busStopCode),
        );
      }
    }

    Navigator.pop(context);
  }

  busArrivalWithData() {
    return Expanded(
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          for (var bus in busArrivalData.values)
            Dismissible(
              key: Key(bus['busService']),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        busType(bus['nextBus']['type'].toString()),
                        size: 32,
                        color: Colors.blue[600],
                      ),
                    )
                  ],
                ),
                title: Text(
                  bus['busService'].toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(bus['destinationName'].toString()),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        bus['nextBus']['feature'].toString() == "WAB"
                            ? Icon(
                                busFeaturesIcon(bus['nextBus']['feature']),
                                color: Colors.black,
                                size: 16,
                              )
                            : Text(""),
                        SizedBox(width: 5),
                      ],
                    ),
                    SizedBox(width: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          bus['nextBus']['estimatedArrival'].toString(),
                          style: TextStyle(
                            fontSize:
                                bus['nextBus']['estimatedArrival'].toString() ==
                                        "NA"
                                    ? 16
                                    : 20,
                            fontWeight: FontWeight.w500,
                            color:
                                bus['nextBus']['estimatedArrival'].toString() ==
                                        "NA"
                                    ? Colors.grey
                                    : busFeaturesColor(bus['nextBus']['load']),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                          child: VerticalDivider(
                            thickness: 1,
                            width: 20,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          bus['nextBus2']['estimatedArrival'].toString(),
                          style: TextStyle(
                            fontSize: bus['nextBus2']['estimatedArrival']
                                        .toString() ==
                                    "NA"
                                ? 16
                                : 20,
                            fontWeight: FontWeight.w500,
                            color: bus['nextBus2']['estimatedArrival']
                                        .toString() ==
                                    "NA"
                                ? Colors.grey
                                : busFeaturesColor(bus['nextBus2']['load']),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                          child: VerticalDivider(
                            thickness: 1,
                            width: 20,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          bus['nextBus3']['estimatedArrival'].toString(),
                          style: TextStyle(
                            fontSize: bus['nextBus3']['estimatedArrival']
                                        .toString() ==
                                    "NA"
                                ? 16
                                : 20,
                            fontWeight: FontWeight.w500,
                            color: bus['nextBus3']['estimatedArrival']
                                        .toString() ==
                                    "NA"
                                ? Colors.grey
                                : busFeaturesColor(bus['nextBus3']['load']),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                onTap: () {
                  setState(() {
                    stopTimer = true;
                    refreshTimer.cancel();
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchBusRoute(bus['busService']),
                    ),
                  ).then((value) async {
                    // IF USER RETURN TO THIS PAGE
                    setState(() {
                      stopTimer = false;
                    });
                    await initPageData(widget.busStopCode);
                  });
                },
                onLongPress: () {
                  setState(() {
                    stopTimer = true;
                    refreshTimer.cancel();
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BusesLocation(
                        bus['busService'],
                        bus['destinationName'],
                        busArrivalData[bus['busService']],
                        widget.busStopCode,
                        widget.title,
                      ),
                    ),
                  ).then((value) async {
                    // IF USER RETURN TO THIS PAGE
                    setState(() {
                      stopTimer = false;
                    });
                    await initPageData(widget.busStopCode);
                  });
                },
              ),
              background: Container(
                color: Theme.of(context).primaryColor,
                alignment: Alignment.center,
                child: Align(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Icon(
                      isDataLoaded
                          ? busesInFavList
                                  .contains(bus['busService'].toString())
                              ? Icons.favorite_rounded
                              : Icons.favorite_outline_rounded
                          : Icons.favorite_outline_rounded,
                      color: Colors.white,
                    ),
                  ),
                  alignment: Alignment.centerLeft,
                ),
              ),
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.startToEnd) {
                  final busService = bus['busService'];
                  final busStopCode = widget.busStopCode;

                  if (isUserLogin) {
                    await addBusServiceToFav(busStopCode, busService);
                    await checkIfBusServiceIsFavOrNot(busStopCode);
                  } else {
                    alertDialog(
                      loginTitle,
                      loginDescription,
                      context,
                    );
                  }

                  return false;
                }
              },
            ),
        ],
      ),
    );
  }

  busArrivalWithNoData() {
    return Expanded(
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: busInThisBusStop.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    MdiIcons.bus,
                    size: 32,
                    color: Colors.blue[600],
                  ),
                )
              ],
            ),
            title: Text(
              busInThisBusStop[index].toString(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("No Estimate Available"),
            trailing: Icon(Icons.keyboard_arrow_right_rounded),
            onTap: () {
              if (busArrivalData.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchBusRoute(
                      busInThisBusStop[index].toString(),
                    ),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initPageData(widget.busStopCode);
  }

  @override
  void dispose() {
    print(stopTimer);
    print(refreshTimer);
    if (refreshTimer != null) {
      refreshTimer.cancel();
      print("Timer removed");
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var currentTime =
        DateFormat("d MMM yyyy, h:mm a").format(DateTime.now().toLocal());

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          if (busArrivalData.isNotEmpty)
            IconButton(
              icon: Icon(Icons.refresh_rounded),
              onPressed: () {
                initPageData(widget.busStopCode);
              },
            )
        ],
      ),
      body: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                color: Theme.of(context).primaryColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      widget.roadName + " • " + widget.busStopCode,
                      style: TextStyle(color: Colors.grey[300]),
                    )
                  ],
                ),
              ),
              if (isDataLoaded)
                if (busArrivalData.isNotEmpty) legendForBus(),
              if (busArrivalData.isEmpty)
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      isDataLoaded && busArrivalData.isEmpty
                          ? Text(
                              "No buses available",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : Text(
                              "Loading...",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      isDataLoaded && busArrivalData.isEmpty
                          ? busInThisBusStopLoadedFinish &&
                                  busInThisBusStop[0] != "Not Found"
                              ? Text(
                                  "But here are the buses serving at this bus stop")
                              : Text("As of $currentTime")
                          : Text("Hold on while we retrieve the information")
                    ],
                  ),
                ),
              busArrivalData.isEmpty
                  ? busInThisBusStopLoadedFinish &&
                          busInThisBusStop[0] != "Not Found"
                      ? busArrivalWithNoData()
                      : Text("")
                  : busArrivalWithData(),
            ],
          ),
        ],
      ),
    );
  }
}
