import 'package:bus_express/model/api.dart';
import 'package:bus_express/model/constants.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:bus_express/model/global.dart';
import 'package:bus_express/view/components/customScaffold.dart';
import 'package:bus_express/view/search/busArrival/busArrival.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:timeline_tile/timeline_tile.dart';

class SearchBusRoute extends StatefulWidget {
  final String busService;
  final String busOperator;
  SearchBusRoute(this.busService, this.busOperator);

  @override
  State<SearchBusRoute> createState() => _SearchBusRouteState();
}

class _SearchBusRouteState extends State<SearchBusRoute> {
  String currentRoadName1 = '';
  String currentRoadName2 = '';

  lastBusTimingBottomSheet(dataSet) {
    final weekdaysFirst = dataSet['weekdaysFirst'];
    final weekdaysLast = dataSet['weekdaysLast'];
    final saturdayFirst = dataSet['saturdayFirst'];
    final saturdayLast = dataSet['saturdayLast'];
    final sundayFirst = dataSet['sundayFirst'];
    final sundayLast = dataSet['sundayLast'];

    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dataSet['busStopName'],
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          DataTable(
            horizontalMargin: 0,
            headingRowHeight: 30,
            dataRowHeight: 40,
            columns: [
              DataColumn(label: Text('Day')),
              DataColumn(label: Text('First Bus')),
              DataColumn(label: Text('Last Bus')),
            ],
            rows: [
              DataRow(
                cells: [
                  DataCell(Text('Monday - Friday')),
                  DataCell(Text(weekdaysFirst)),
                  DataCell(Text(weekdaysLast)),
                ],
              ),
              DataRow(
                cells: [
                  DataCell(Text('Saturday')),
                  DataCell(Text(saturdayFirst)),
                  DataCell(Text(saturdayLast)),
                ],
              ),
              DataRow(
                cells: [
                  DataCell(Text('Sunday/PH')),
                  DataCell(Text(sundayFirst)),
                  DataCell(Text(sundayLast)),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  listTitleForRoute(
    Map busStopData,
    Map<dynamic, dynamic> data,
    int direction,
  ) {
    final busStopName = busStopData['busStopName'];
    final roadName = busStopData['roadName'];
    final busStopCode = busStopData['busStopCode'];
    final distance = busStopData['distance'].toString() + " km";

    if (direction == 1) {
      currentRoadName1 = roadName;
    } else {
      currentRoadName2 = roadName;
    }

    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20),
      title: Text(busStopName),
      subtitle: Text(distance != null ? distance : "Distance not avaialble"),
      trailing: Icon(FluentIcons.chevron_right_24_filled, size: 18),
      leading: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Color.lerp(Colors.white, primaryColor, 0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          MdiIcons.busStop,
          size: 32,
          color: primaryColor,
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchBusArrival(
              busStopName,
              busStopCode,
              roadName,
            ),
          ),
        );
      },
      onLongPress: () => showModalBottomSheet(
        context: context,
        backgroundColor: Color.fromRGBO(0, 0, 0, 0),
        builder: (BuildContext context) {
          return lastBusTimingBottomSheet(busStopData);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic> data = allBusRouteData[widget.busService];
    Map<dynamic, dynamic> directionOneData = data['Direction 1'];
    Map<dynamic, dynamic> directionTwoData = data['Direction 2'];

    int amountOfDirection = data.length;

    if (directionTwoData == null) {
      amountOfDirection = 1;
    } else {
      amountOfDirection = amountOfDirection;
    }

    int directionOneLength = directionOneData.length - 1;
    String directionOneEndLocation =
        directionOneData[directionOneLength.toString()]['busStopName'];
    String directionTwoEndLocation = '';

    if (amountOfDirection == 2) {
      int directionTwoLength = directionTwoData.length - 1;
      directionTwoEndLocation =
          directionTwoData[directionTwoLength.toString()]['busStopName'];
    }

    return CustomScaffold(
      widget.busService,
      widget.busOperator,
      DefaultTabController(
        length: amountOfDirection,
        child: Column(
          children: [
            TabBar(
              indicatorColor: Theme.of(context).primaryColor,
              labelColor: Theme.of(context).primaryColor,
              tabs: [
                Tab(text: directionOneEndLocation),
                if (amountOfDirection == 2) Tab(text: directionTwoEndLocation)
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ListView(
                    padding: const EdgeInsets.only(bottom: 20),
                    physics: BouncingScrollPhysics(),
                    children: [
                      for (var busStop in directionOneData.values) ...[
                        if (busStop['roadName'] != currentRoadName1) ...[
                          listViewHeader(busStop['roadName'], context),
                        ],
                        listTitleForRoute(busStop, directionOneData, 1),
                      ]
                    ],
                  ),
                  if (amountOfDirection == 2)
                    ListView(
                      padding: const EdgeInsets.only(bottom: 20),
                      physics: BouncingScrollPhysics(),
                      children: [
                        for (var busStop in directionTwoData.values) ...[
                          if (busStop['roadName'] != currentRoadName2) ...[
                            listViewHeader(busStop['roadName'], context),
                          ],
                          listTitleForRoute(busStop, directionTwoData, 2),
                        ]
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      2,
    );
  }
}
