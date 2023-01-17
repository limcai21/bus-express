import 'package:bus_express/custom_icons_icons.dart';
import 'package:bus_express/model/global.dart';
import 'package:bus_express/view/search/busArrival/busArrival.dart';
import 'package:bus_express/view/search/busRoute/busRoute.dart';
import 'package:bus_express/view/search/components/roadAlert.dart';
import 'package:bus_express/view/search/search.dart';
import 'package:flutter/material.dart';

class CustomSearchTabBar extends StatefulWidget {
  int selectedIndex;
  CustomSearchTabBar({this.selectedIndex});

  @override
  State<CustomSearchTabBar> createState() => _CustomSearchTabBarState();
}

class _CustomSearchTabBarState extends State<CustomSearchTabBar> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: searchTabIndex,
      length: 3,
      child: Column(
        children: [
          TabBar(
            onTap: (index) => setState(() => searchTabIndex = index),
            indicatorColor: Theme.of(context).primaryColor,
            labelColor: Theme.of(context).primaryColor,
            tabs: [
              Tab(text: "BUS STOPS"),
              Tab(text: "BUS SERVICE"),
              Tab(text: "ROADS")
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    for (var busStop in searchBusStopsData.values)
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        title: Text(
                          busStop['description'],
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        trailing: Icon(CustomIcons.chevron_right, size: 18),
                        subtitle: busStop['error'] != true
                            ? Text((busStop['roadName']).toString() +
                                " • " +
                                (busStop['code']).toString())
                            : Text((busStop['code']).toString()),
                        leading: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            busStop['error'] != true
                                ? dataTile(CustomIcons.bus_stop, Colors.blue)
                                : dataTile(
                                    Icons.error_outline_rounded, Colors.red),
                          ],
                        ),
                        onTap: () => busStop['error'] != true
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SearchBusArrival(
                                    busStop['description'],
                                    busStop['code'],
                                    busStop['roadName'],
                                  ),
                                ),
                              )
                            : null,
                      ),
                  ],
                ),
                ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    for (var busService in searchBusServiceData.values)
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        title: Text(
                          busService['serviceNo'],
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        trailing: Icon(CustomIcons.chevron_right, size: 18),
                        subtitle: Text(busService['operator']),
                        leading: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            busService['error'] != true
                                ? dataTile(CustomIcons.bus, Colors.blue)
                                : dataTile(
                                    Icons.error_outline_rounded, Colors.red),
                          ],
                        ),
                        onTap: () => busService['error'] != true
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SearchBusRoute(
                                    busService['serviceNo'],
                                  ),
                                ),
                              )
                            : null,
                      )
                  ],
                ),
                ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    for (var road in searchAddressData.values)
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        title: Text(
                          road["roadName"],
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        trailing: Icon(CustomIcons.chevron_right, size: 18),
                        subtitle: road['error'] == true
                            ? Text(road['subtitle'])
                            : Text(road['amountOfBusStop'].toString() +
                                " Bus Stops"),
                        leading: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            road['error'] == true
                                ? dataTile(CustomIcons.error_circle, Colors.red)
                                : dataTile(CustomIcons.road_3d, Colors.blue)
                          ],
                        ),
                        onTap: () => road['error'] != true
                            ? roadAlert((road["roadName"]).toString(), context)
                            : null,
                      ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
