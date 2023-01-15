import 'dart:convert';
import 'package:bus_express/model/switchCase.dart';
import 'package:flutter/material.dart';
import 'package:bus_express/model/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

addBusServiceToFav(String busStopCode, String busService) async {
  final prefs = await SharedPreferences.getInstance();
  final usernameFavList = currentLoginUsername + "FavList";

  // CLEAR LIST
  // await prefs.remove(usernameFavList);

  // GET CURRENT FAV LIST
  final String currentUserFavList = prefs.getString(usernameFavList);

  if (currentUserFavList != null) {
    Map<String, dynamic> decodeJSON = jsonDecode(currentUserFavList);
    if (decodeJSON[busStopCode] != null) {
      if (!decodeJSON[busStopCode].contains(busService)) {
        decodeJSON[busStopCode].add(busService);
      } else {
        removeBusServiceFromFav(busStopCode, busService);
      }
    } else {
      decodeJSON[busStopCode] = [busService];
    }

    // SAVING IT
    await prefs.setString(usernameFavList, jsonEncode(decodeJSON));
  } else {
    // USER DOESNT NOT HAVE ANY FAV IN HIS LIST YET
    Map<String, dynamic> temp = {
      busStopCode: [busService]
    };

    // SINCE CANNOT STORE MAP, ENCODE IT TO STRING
    await prefs.setString(usernameFavList, jsonEncode(temp));
  }
}

removeBusServiceFromFav(String busStopCode, String busService) async {
  final prefs = await SharedPreferences.getInstance();
  final usernameFavList = currentLoginUsername + "FavList";
  final String currentUserFavList = prefs.getString(usernameFavList);

  if (currentUserFavList != null) {
    // USER ALR HAS SOME FAV
    Map<String, dynamic> allData = jsonDecode(currentUserFavList);
    final List decodeJSON = jsonDecode(currentUserFavList)[busStopCode];
    if (decodeJSON.length > 1) {
      decodeJSON.removeWhere((element) => element == busService);
      allData[busStopCode] = decodeJSON;
      await prefs.setString(usernameFavList, jsonEncode(allData));
    } else {
      allData.removeWhere((key, value) => key == busStopCode);
      await prefs.setString(usernameFavList, jsonEncode(allData));
    }
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
