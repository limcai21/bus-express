import 'package:bus_express/model/constants.dart';
import 'package:flutter/material.dart';
import 'package:bus_express/model/global.dart';
import 'package:bus_express/model/custom_icons_icons.dart';
import 'package:bus_express/view/components/customScaffold.dart';
import 'package:bus_express/view/search/busArrival/busArrival.dart';

class SearchBusRoute extends StatefulWidget {
  final String busService;
  SearchBusRoute(this.busService);

  @override
  State<SearchBusRoute> createState() => _SearchBusRouteState();
}

class _SearchBusRouteState extends State<SearchBusRoute> {
  String endLocation = '';

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
    int index,
    int lastIndex,
    Map<dynamic, dynamic> data,
  ) {
    if (index + 1 == lastIndex - 1) {
      index++;
    }
    final busStopName = data[(index + 1).toString()]['busStopName'];
    final roadName = data[(index + 1).toString()]['roadName'];
    final busStopCode = data[(index + 1).toString()]['busStopCode'];
    final distance =
        data[(index + 1).toString()]['distance'].toString() + " km";

    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20),
      title: Text(busStopName),
      subtitle: Text(distance != null ? distance : "Distance not avaialble"),
      trailing: Icon(CustomIcons.chevron_right, size: 18),
      leading: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Color.lerp(Colors.white, primaryColor, 0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          CustomIcons.bus_stop,
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
          return lastBusTimingBottomSheet(data[(index + 1).toString()]);
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
    amountOfDirection = directionTwoData.isEmpty
        ? amountOfDirection = 1
        : amountOfDirection = amountOfDirection;

    int lastIndex = directionOneData.length;
    if (directionOneData[(directionOneData.length).toString()] == null) {
      lastIndex = directionOneData.length + 1;
    }

    String directionOneEndLocation =
        directionOneData[lastIndex.toString()]['busStopName'];
    String directionTwoEndLocation = '';
    String subtitle = directionOneEndLocation;
    endLocation = directionOneEndLocation;

    if (amountOfDirection == 2) {
      directionTwoEndLocation = directionOneData['1']['busStopName'];
      subtitle = directionOneEndLocation + " ⇆ " + directionTwoEndLocation;
    }

    return CustomScaffold(
      widget.busService,
      subtitle,
      DefaultTabController(
        length: amountOfDirection,
        child: Column(
          children: [
            TabBar(
              indicatorColor: Theme.of(context).primaryColor,
              onTap: (value) {
                setState(() {
                  value == 0
                      ? endLocation = directionOneEndLocation
                      : endLocation = directionTwoEndLocation;
                });
              },
              labelColor: Theme.of(context).primaryColor,
              tabs: [
                Tab(text: directionOneEndLocation),
                if (amountOfDirection == 2) Tab(text: directionTwoEndLocation)
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: directionOneData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return listTitleForRoute(
                        index,
                        lastIndex,
                        directionOneData,
                      );
                    },
                  ),
                  if (amountOfDirection == 2)
                    ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: directionTwoData.length,
                      itemBuilder: (BuildContext context, int index) {
                        return listTitleForRoute(
                          index,
                          lastIndex,
                          directionTwoData,
                        );
                      },
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
