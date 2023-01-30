import 'dart:convert';
import 'package:bus_express/model/switchCase.dart';
import 'package:flutter/material.dart';
import 'package:bus_express/model/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

addBusServiceToFav(String busStopCode, String busService) async {
  final prefs = await SharedPreferences.getInstance();

  // CLEAR LIST
  // await prefs.remove(usernameFavList);

  // GET CURRENT FAV LIST
  final Map<String, dynamic> userData =
      jsonDecode(prefs.getString(currentLoginUsername));
  Map<String, dynamic> currentUserFavList = userData['favourite'];

  if (currentUserFavList != null) {
    if (currentUserFavList[busStopCode] != null) {
      if (currentUserFavList[busStopCode].contains(busService)) {
        removeBusServiceFromFav(busStopCode, busService);
      } else {
        currentUserFavList[busStopCode].add(busService);
      }
    } else {
      currentUserFavList[busStopCode] = [busService];
      userData['favourite'] = currentUserFavList;
    }

    // // SAVING IT
    await prefs.setString(currentLoginUsername, jsonEncode(userData));
  } else {
    // USER DOESNT NOT HAVE ANY FAV IN HIS LIST YET
    Map<String, dynamic> temp = {
      busStopCode: [busService]
    };

    userData["favourite"] = temp;

    // SINCE CANNOT STORE MAP, ENCODE IT TO STRING
    await prefs.setString(currentLoginUsername, jsonEncode(userData));
  }

  print("add");
  print(userData['favourite'][busStopCode]);
}

removeBusServiceFromFav(String busStopCode, String busService) async {
  final prefs = await SharedPreferences.getInstance();
  final String currentUserFavList = prefs.getString(currentLoginUsername);

  if (currentUserFavList != null) {
    // USER ALR HAS SOME FAV
    Map<String, dynamic> allData = jsonDecode(currentUserFavList);
    List userFavData = allData['favourite'][busStopCode];

    if (userFavData.length > 1) {
      userFavData.removeWhere((element) => element == busService);
      allData["favourite"][busStopCode] = userFavData;
      await prefs.setString(currentLoginUsername, jsonEncode(allData));
    } else {
      allData["favourite"].removeWhere((key, value) => key == busStopCode);
      await prefs.setString(currentLoginUsername, jsonEncode(allData));
    }

    print("remove");
    print(userFavData);
  }
}

legendPill(Color color, String title, IconData icon) {
  return Container(
    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(5),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: Colors.white,
        ),
        SizedBox(width: 5),
        Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    ),
  );
}

legendForBus() {
  return Container(
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Legends:"),
        SizedBox(height: 5),
        Container(
          height: 24,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
          child: ListView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: [
              legendPill(
                busFeaturesColor("SEA"),
                "Seats Available",
                busFeaturesIcon("SEA"),
              ),
              SizedBox(width: 5),
              legendPill(
                busFeaturesColor("SDA"),
                busFeaturesWord("SDA"),
                busFeaturesIcon("SDA"),
              ),
              SizedBox(width: 5),
              legendPill(
                busFeaturesColor("LSD"),
                busFeaturesWord("LSD"),
                busFeaturesIcon("LSD"),
              ),
              SizedBox(width: 5),
              legendPill(
                busFeaturesColor("WAB"),
                busFeaturesWord("WAB"),
                busFeaturesIcon("WAB"),
              ),
              SizedBox(width: 5),
              legendPill(
                busFeaturesColor("SD"),
                busFeaturesWord("SD"),
                busFeaturesIcon("SD"),
              ),
              SizedBox(width: 5),
              legendPill(
                busFeaturesColor("DD"),
                busFeaturesWord("DD"),
                busFeaturesIcon("DD"),
              ),
              SizedBox(width: 5),
              legendPill(
                busFeaturesColor('BD'),
                busFeaturesWord("BD"),
                busFeaturesIcon('BD'),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
