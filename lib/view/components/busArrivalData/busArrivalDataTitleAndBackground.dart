import 'package:bus_express/model/custom_icons_icons.dart';
import 'package:bus_express/model/switchCase.dart';
import 'package:bus_express/model/constants.dart';
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
                  size: 12,
                )
              : Text("")
          : Text(""),
    ],
  );
}

busArrivalDataBackground(context, {List busesInFavList, String currentBus}) {
  IconData bgIcon = CustomIcons.delete;
  Color bgColor = Colors.red;

  if (busesInFavList != null) {
    bgColor = Theme.of(context).primaryColor;
    if (busesInFavList.contains(currentBus)) {
      bgIcon = CustomIcons.favourite_filled;
    } else {
      bgIcon = CustomIcons.favourite_regular;
    }
  }

  return Container(
    color: bgColor,
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
