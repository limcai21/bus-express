import 'package:bus_express/model/switchCase.dart';
import 'package:bus_express/model/constants.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

busArrivalDataTitle(String busService, data) {
  return Row(
    children: [
      Text(
        busService.toString(),
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(width: 5),
      data != null
          ? data['nextBus']['feature'].toString() == "WAB"
              ? Icon(
                  busFeaturesIcon(data['nextBus']['feature']),
                  color: Colors.black,
                  size: 14,
                )
              : Text("")
          : Text(""),
    ],
  );
}

busArrivalDataBackground(context, {List busesInFavList, String currentBus}) {
  IconData bgIcon = FluentIcons.heart_24_filled;

  if (busesInFavList != null) {
    if (!busesInFavList.contains(currentBus)) {
      bgIcon = FluentIcons.heart_24_regular;
    }
  }

  return Container(
    color: Theme.of(context).primaryColor,
    alignment: Alignment.center,
    child: Align(
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Icon(
          bgIcon,
          color: Colors.white,
        ),
      ),
      alignment: Alignment.centerLeft,
    ),
  );
}

busArrivalDataBackground2() {
  return Container(
    color: Colors.black,
    padding: const EdgeInsets.all(20),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          swipeLeftToRightInstruction,
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.end,
        )
      ],
    ),
  );
}
