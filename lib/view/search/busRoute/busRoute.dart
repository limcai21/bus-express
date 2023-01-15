import 'package:bus_express/view/profile/company/components/contactFunctions.dart';
import 'package:flutter/material.dart';
import 'package:bus_express/model/api.dart';
import 'package:bus_express/model/constants.dart';
import 'package:bus_express/view/components/alertDialog.dart';
import 'package:bus_express/view/components/customScaffold.dart';
import 'package:bus_express/view/components/loadingAlert.dart';
import 'package:bus_express/view/search/busArrival/busArrival.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SearchBusRoute extends StatefulWidget {
  String busService;
  SearchBusRoute(this.busService);

  @override
  State<SearchBusRoute> createState() => _SearchBusRouteState();
}

class _SearchBusRouteState extends State<SearchBusRoute> {
  bool isDataLoaded = false;
  Map<String, dynamic> busRouteData = {};
  String directionOneEndPlace = "Direction 1";
  String directionTwoEndPlace = "Direction 2";
  int amountOfDirection = 2;
  String selectedTabBarIndex = "Direction 1";

  initPageData(busService) async {
    loadingAlert(context);
    busRouteData = await Bus().route(busService.toString());
    if (busRouteData != null) {
      var directionOneLength = (busRouteData['Direction 1'].length).toString();
      var directionTwoLength = (busRouteData['Direction 2'].length).toString();

      setState(() {
        busRouteData = busRouteData;
        if (busRouteData['Direction 2'].isEmpty) {
          amountOfDirection = 1;
          directionOneEndPlace = "To " +
              busRouteData['Direction 1'][directionOneLength]['busStopName'];
          selectedTabBarIndex = directionOneEndPlace;
        } else {
          directionTwoEndPlace = "To " +
              busRouteData['Direction 2'][directionTwoLength]['busStopName'];
          directionOneEndPlace = "To " +
              busRouteData['Direction 1'][directionOneLength]['busStopName'];
          selectedTabBarIndex = directionOneEndPlace;
        }
        isDataLoaded = true;
        Navigator.pop(context);
      });
    } else {
      // NO BUS TIMING ALR
      setState(() {
        isDataLoaded = true;
      });
      Navigator.pop(context);
      Widget toFeedbackForm = TextButton(
        child: Text(
          'FEEDBACK',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        onPressed: () => launchEmail(
          companyFeedbackEmail,
          'Feedback - No Bus Route Available',
        ),
      );
      await alertDialog(
        busRouteNotFoundTitle,
        busService + busRouteNotFoundDescription,
        context,
        additionalActions: toFeedbackForm,
      );
      Navigator.pop(context);
    }
  }

  lastBusTimingBottomSheet(dataSet, selectedTabBarIndex) {
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
          Text(
            selectedTabBarIndex,
            style: TextStyle(fontSize: 12),
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

  listTitleForRoute(int index, String direction, String selectedTabBarIndex) {
    final busStopName =
        busRouteData[direction][(index + 1).toString()]['busStopName'];
    final roadName =
        busRouteData[direction][(index + 1).toString()]['roadName'];
    final busStopCode =
        busRouteData[direction][(index + 1).toString()]['busStopCode'];
    final distance =
        busRouteData[direction][(index + 1).toString()]['distance'].toString() +
            " km";
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20),
      title: Text(busStopName),
      subtitle: Text(distance != null ? distance : "Distance not avaialble"),
      trailing: Icon(Icons.chevron_right_rounded),
      leading: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.blue[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          MdiIcons.busStop,
          size: 32,
          color: Colors.blue[600],
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
          return lastBusTimingBottomSheet(
            busRouteData[direction][(index + 1).toString()],
            selectedTabBarIndex,
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initPageData(widget.busService);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      widget.busService,
      amountOfDirection == 1
          ? directionOneEndPlace
          : directionOneEndPlace + ' / ' + directionTwoEndPlace,
      DefaultTabController(
        length: amountOfDirection,
        child: Column(
          children: [
            if (busRouteData != null && isDataLoaded)
              TabBar(
                onTap: (value) {
                  setState(() {
                    value == 0
                        ? selectedTabBarIndex = directionOneEndPlace
                        : selectedTabBarIndex = directionTwoEndPlace;
                  });
                },
                labelColor: Theme.of(context).primaryColor,
                tabs: [
                  Tab(text: directionOneEndPlace),
                  if (amountOfDirection == 2) Tab(text: directionTwoEndPlace),
                ],
              ),
            isDataLoaded
                ? busRouteData != null
                    ? Expanded(
                        child: TabBarView(
                          children: [
                            ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: busRouteData['Direction 1'].length,
                              itemBuilder: (BuildContext context, int index) {
                                return listTitleForRoute(
                                    index, 'Direction 1', selectedTabBarIndex);
                              },
                            ),
                            if (amountOfDirection == 2)
                              ListView.builder(
                                physics: BouncingScrollPhysics(),
                                itemCount: busRouteData['Direction 2'].length,
                                itemBuilder: (BuildContext context, int index) {
                                  return listTitleForRoute(index, 'Direction 2',
                                      selectedTabBarIndex);
                                },
                              ),
                          ],
                        ),
                      )
                    : Text("")
                : Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.all(15),
                    child: Text("Loading..."),
                  )
          ],
        ),
      ),
    );
  }
}
