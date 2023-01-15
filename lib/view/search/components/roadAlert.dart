import 'package:bus_express/view/components/alertSimpleDialog.dart';
import 'package:flutter/material.dart';
import 'package:bus_express/model/constants.dart';
import 'package:bus_express/model/global.dart';
import 'package:bus_express/view/components/alertDialog.dart';
import 'package:bus_express/view/search/busArrival/busArrival.dart';

Future<void> roadAlert(roadName, context) async {
  searchForBusStopInThisRoad() {
    Map<String, dynamic> tempSearchHolder = {};
    allBusStopsData.forEach((key, value) {
      if (value["roadName"] == roadName) {
        tempSearchHolder[key] = value;
      }
    });
    return tempSearchHolder;
  }

  if (searchForBusStopInThisRoad().length <= 0) {
    alertDialog(
      noBusStopInThisRouteTitle,
      noBusStopInThisRouteDescription,
      context,
    );
  } else {
    List<Widget> tempHolder = [];
    for (var busStop in searchForBusStopInThisRoad().values) {
      tempHolder.add(
        SimpleDialogOption(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 20,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchBusArrival(
                  busStop['description'],
                  busStop['code'],
                  busStop['roadName'],
                ),
              ),
            );
          },
          child: Text((busStop["description"]).toString()),
        ),
      );
    }

    return alertSimpleDialog('Select a Bus Stop:', tempHolder, context);
  }
}
