import 'package:bus_express/model/constants.dart';
import 'package:bus_express/model/global.dart';
import 'package:bus_express/view/search/busArrival/busArrival.dart';
import 'package:bus_express/view/search/busRoute/busRoute.dart';
import 'package:bus_express/view/search/components/roadAlert.dart';
import 'package:bus_express/view/search/components/searchFunction.dart';
import 'package:bus_express/view/search/search.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CustomSearchTabBar extends StatefulWidget {
  @override
  State<CustomSearchTabBar> createState() => _CustomSearchTabBarState();
}

class _CustomSearchTabBarState extends State<CustomSearchTabBar> {
  filterBusServiceType() {
    setState(() {
      searchBusServiceData =
          DataSearch().busServiceSearching(searchData: searchQuery);
    });
  }

  filterCustomChips(int index) {
    var isSelected = filters.contains(allBusServiceType[index]);
    return ChoiceChip(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      label: Text(allBusServiceType[index]),
      selected: isSelected,
      onSelected: (bool value) {
        setState(() {
          if (value) {
            if (!filters.contains(allBusServiceType[index])) {
              filters.add(allBusServiceType[index]);
            }
          } else {
            filters.removeWhere((String cat) {
              return cat == allBusServiceType[index];
            });
          }

          filterBusServiceType();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: searchTabIndex,
      length: 3,
      child: Column(
        children: [
          TabBar(
            onTap: (index) => searchTabIndex = index,
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
                // BUS STOP
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
                        trailing: busStop['error'] != true
                            ? Icon(
                                FluentIcons.chevron_right_24_filled,
                                size: 18,
                              )
                            : null,
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
                                ? customLeadingIcon(
                                    MdiIcons.busStop, primaryColor)
                                : customLeadingIcon(
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

                // BUS SERVICE
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // DATA
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 1,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        child: ListView(
                          physics: BouncingScrollPhysics(),
                          children: [
                            for (var busService in searchBusServiceData.values)
                              ListTile(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 20),
                                title: Text(
                                  busService['serviceNo'],
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                trailing: busService['error'] != true
                                    ? Icon(
                                        FluentIcons.chevron_right_24_filled,
                                        size: 18,
                                      )
                                    : null,
                                subtitle: Text(busService['operator']),
                                leading: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    busService['error'] != true
                                        ? customLeadingIcon(
                                            MdiIcons.bus, primaryColor)
                                        : customLeadingIcon(
                                            Icons.error_outline_rounded,
                                            Colors.red),
                                  ],
                                ),
                                onTap: () => busService['error'] != true
                                    ? Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SearchBusRoute(
                                            busService['serviceNo'],
                                            busService['operator'],
                                          ),
                                        ),
                                      )
                                    : null,
                              )
                          ],
                        ),
                      ),
                    ),

                    // FILTER
                    Container(
                      height: 60,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: ListView.separated(
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: allBusServiceType.length,
                              itemBuilder: (context, index) {
                                return filterCustomChips(index);
                              },
                              separatorBuilder: (context, index) {
                                return SizedBox(width: 5);
                              },
                            ),
                          ),
                          SizedBox(
                            height: 15,
                            child: VerticalDivider(
                              thickness: 2,
                              width: 20,
                              color: Colors.grey[400],
                            ),
                          ),
                          TextButton(
                            style: ButtonStyle(
                              overlayColor: MaterialStateProperty.all(
                                Color.lerp(Colors.white, primaryColor, 0.1),
                              ),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                            onPressed: filters.length > 0
                                ? () {
                                    setState(() {
                                      filters = [];
                                      searchBusServiceData = allBusServiceData;
                                    });
                                  }
                                : null,
                            child: Text(
                              filters.length > 0 ? "CLEAR" : "FILTER",
                              style: TextStyle(
                                color: filters.isEmpty
                                    ? Colors.grey
                                    : primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // ROAD
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
                        trailing: road['error'] != true
                            ? Icon(
                                FluentIcons.chevron_right_24_filled,
                                size: 18,
                              )
                            : null,
                        subtitle: road['error'] == true
                            ? Text(road['subtitle'])
                            : Text(road['amountOfBusStop'].toString() +
                                " Bus Stops"),
                        leading: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            road['error'] == true
                                ? customLeadingIcon(
                                    FluentIcons.error_circle_24_regular,
                                    Colors.red,
                                  )
                                : customLeadingIcon(
                                    MdiIcons.roadVariant,
                                    primaryColor,
                                  )
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
