import 'package:bus_express/model/switchCase.dart';
import 'package:flutter/material.dart';

busArrivalDataLeading(data) {
  return Column(
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
          busFeaturesIcon(
              data == null ? "default" : data['nextBus']['type'].toString()),
          size: 32,
          color: Colors.blue[600],
        ),
      )
    ],
  );
}

// LAYOUT 1
// busArrivalDataTrailingTiming(data) {
//   return Text(
//     data['estimatedArrival'].toString(),
//     style: TextStyle(
//       fontSize: data['estimatedArrival'].toString() == "NA" ? 16 : 20,
//       fontWeight: FontWeight.w500,
//       color: data['estimatedArrival'].toString() == "NA"
//           ? Colors.grey
//           : busFeaturesColor(data['load']),
//     ),
//   );
// }

// LAYOUT 2
busArrivalDataTrailingTiming(data) {
  String eta = data['estimatedArrival'].toString();
  Color bottomTextColor =
      eta == "NA" ? Colors.grey : busFeaturesColor(data['load']);
  Color textColor = (eta == "NA" ? Colors.grey : Colors.black);
  FontWeight fontWeight = (eta == "NA" ? FontWeight.normal : FontWeight.w500);

  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        data['estimatedArrival'].toString(),
        style: TextStyle(
          fontSize: data['estimatedArrival'].toString() == "NA" ? 16 : 20,
          fontWeight: fontWeight,
          color: textColor,
        ),
      ),
      if (data['estimatedArrival'].toString() != "NA")
        Container(
          margin: const EdgeInsets.only(top: 3),
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          decoration: BoxDecoration(
            color: bottomTextColor,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
    ],
  );
}

busArrivalDataTrailing(data, bool gotData) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: gotData
        ? [
            Row(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    busArrivalDataTrailingTiming(data['nextBus']),
                    SizedBox(
                      height: 25,
                      child: VerticalDivider(
                        thickness: 1,
                        width: 20,
                        color: Colors.grey,
                      ),
                    ),
                    busArrivalDataTrailingTiming(data['nextBus2']),
                    SizedBox(
                      height: 25,
                      child: VerticalDivider(
                        thickness: 1,
                        width: 20,
                        color: Colors.grey,
                      ),
                    ),
                    busArrivalDataTrailingTiming(data['nextBus3']),
                  ],
                ),
              ],
            ),
          ]
        : [
            Text(
              "Not Available",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
  );
}
