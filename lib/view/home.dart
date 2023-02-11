import 'package:bus_express/model/api.dart';
import 'package:bus_express/model/constants.dart';
import 'package:bus_express/model/global.dart';
import 'package:bus_express/view/components/alert/alertDialog.dart';
import 'package:bus_express/view/components/alert/alertSimpleDialog.dart';
import 'package:bus_express/view/components/alert/alertLoading.dart';
import 'package:bus_express/view/components/startUpData.dart';
import 'package:bus_express/view/search/busArrival/busArrival.dart';
import 'package:bus_express/view/search/busRoute/busRoute.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:location/location.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:open_settings/open_settings.dart';
import 'dart:math' as math;
import 'components/button/textButton.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool nearbyBusStopBool = true;
  var mapMaker = {};
  double zoom = 10;
  MapController mapController = MapController();
  CenterOnLocationUpdate centerOnLocationUpdate;

  Future<void> busRouteAlert(busData, context, busStopCode) async {
    if (busData[0] == "Not Found") {
      return alertDialog(
        busRouteNotAvailableForBusStopTitle,
        busRouteNotAvailableForBusStopDescription,
        context,
        additionalActions: feedbackTextButton(
          'Feedback - Bus Route not Available',
          context,
        ),
      );
    } else {
      List<Widget> tempHolder = [];
      for (var bus in busData) {
        tempHolder.add(
          SimpleDialogOption(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 20,
            ),
            child: Text(bus.toString()),
            onPressed: () async {
              String subtitle = allBusServiceData[bus.toString()] != null
                  ? allBusServiceData[bus.toString()]['operator']
                  : await Bus().serviceOperator(busStopCode, bus.toString());

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchBusRoute(
                    bus.toString(),
                    subtitle,
                  ),
                ),
              );
            },
          ),
        );
      }
      return alertSimpleDialog('Select a Bus:', tempHolder, context);
    }
  }

  errorWhenNoNearbyBusStop() {
    if (nearbyBusStopsData == null) {
      alertDialog(
        "Hmm..",
        'Something went wrong when getting your nearby bus stop.',
        context,
        additionalActions: feedbackTextButton(
          'Feedback - No Nearby Bus Stop Available',
          context,
        ),
      );
    }
  }

  busStopModalSheet(
    String busStopCode,
    String busStopName,
    String roadName,
  ) async {
    List buses = await Bus().service(busStopCode);

    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    busStopName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.blue[900],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      busStopCode,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (buses.length > 0) ...[
                    if (buses[0] != 'Not Found') ...[
                      Text("Available Now"),
                    ] else ...[
                      Text("No Buses Operating Here"),
                    ],
                  ] else ...[
                    Text("No buses operating now"),
                  ],
                  SizedBox(height: 5),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: buses.length > 0 && buses[0] != 'Not Found'
                        ? Wrap(
                            spacing: 3,
                            runSpacing: 3,
                            children: [
                              for (var bus in buses) ...[
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.green[900],
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    bus.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ]
                            ],
                          )
                        : null,
                  )
                ],
              ),
              if (buses.isNotEmpty) ...[
                SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(primaryColor),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                        icon: Icon(FluentIcons.clock_24_filled, size: 20),
                        label: Text("Arrival Timing"),
                        onPressed: () async {
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
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ButtonStyle(
                          side: MaterialStateProperty.all(
                            BorderSide(width: 2, color: primaryColor),
                          ),
                          overlayColor: MaterialStateProperty.all(
                            Color.lerp(Colors.white, primaryColor, 0.1),
                          ),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                        icon: Icon(
                          MdiIcons.routes,
                          size: 20,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          busRouteAlert(buses, context, busStopCode);
                        },
                        label: Text(
                          "Bus Route",
                          style: TextStyle(color: primaryColor),
                        ),
                      ),
                    ),
                  ],
                )
              ] else ...[
                SizedBox(height: 10),
              ],
            ],
          ),
        );
      },
    );
  }

  setZoomAndCenter(data) {
    centerOnLocationUpdate = CenterOnLocationUpdate.first;

    location.getLocation().then((value) async {
      var lat = value.latitude;
      var long = value.longitude;

      centerPoint = LatLng(lat, long);
    });

    if (nearbyBusStopBool) {
      mapController.move(centerPoint, 17);
    } else {
      mapController.move(centerPoint, 16);
    }
  }

  onPressFAB() async {
    await checkLocationServiceAndPermission();
    if ((locationServiceEnabled == true) &&
        (permissionGranted != PermissionStatus.denied) &&
        (permissionGranted != PermissionStatus.deniedForever)) {
      await nearbyBusStop();
    }

    setState(() {
      if ((locationServiceEnabled == true) &&
          (permissionGranted != PermissionStatus.denied) &&
          (permissionGranted != PermissionStatus.deniedForever)) {
        // TRUE = NEARBY, FALSE = ALL
        nearbyBusStopBool = !nearbyBusStopBool;

        if (nearbyBusStopBool) {
          if (nearbyBusStopsData != null) {
            mapMaker = nearbyBusStopsData;
          } else {
            mapMaker = {};
          }
        } else {
          mapMaker = allBusStopsData;
        }

        setZoomAndCenter(mapMaker);

        // CHECK IF THERE IS ANY DATA IN NEARBY BUS STOP
        if (nearbyBusStopBool) {
          errorWhenNoNearbyBusStop();
        }
      } else {
        alertDialog(
          permissionDisabledTitle,
          permissionDisabled,
          context,
          additionalActions: customTextButton(
            context,
            "Settings",
            () => OpenSettings.openLocationSetting(),
          ),
        );
      }
    });
  }

  loadWhichMap() async {
    await checkLocationServiceAndPermission();
    print("Done getting Location Service and Permission");

    if ((locationServiceEnabled == true) &&
        (permissionGranted != PermissionStatus.denied) &&
        (permissionGranted != PermissionStatus.deniedForever)) {
      print("Loading Neaby Map...");
      loadingAlert(context);

      await nearbyBusStop();

      if (this.mounted) {
        setState(() {
          nearbyBusStopBool = true;
          isAllPermissionEnabled = true;
          nearbyBusStopBool
              ? mapMaker = nearbyBusStopsData != null ? nearbyBusStopsData : {}
              : mapMaker = allBusStopsData;
          setZoomAndCenter(mapMaker);
        });

        Navigator.of(context).pop();
      }

      errorWhenNoNearbyBusStop();
    } else {
      print("Loading all bus stop Map...");
      // await BusStop().all();
      if (this.mounted) {
        setState(() {
          nearbyBusStopBool = false;
          isAllPermissionEnabled = false;
          mapController.move(
              LatLng(1.2863532585353976, 103.85142618405948), 16);
          mapMaker = allBusStopsData;
          centerOnLocationUpdate = CenterOnLocationUpdate.never;
        });

        // Navigator.of(context).pop();

        alertDialog(
          zoomOutToViewMapTitle,
          zoomOutToViewMap,
          context,
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    print("Home (initState)");
    loadWhichMap();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        new FlutterMap(
          mapController: mapController,
          options: new MapOptions(
            zoom: zoom,
            center: centerPoint,
            plugins: [
              LocationMarkerPlugin(
                centerOnLocationUpdate: centerOnLocationUpdate,
              )
            ],
          ),
          layers: [
            new TileLayerOptions(
              urlTemplate: mapUrlTemplate,
              subdomains: mapSubdomain,
            ),
            if (isAllPermissionEnabled) LocationMarkerLayerOptions(),
            new MarkerLayerOptions(
              markers: [
                for (var busStop in mapMaker.values) ...[
                  new Marker(
                    point: new LatLng(
                      busStop["latitude"],
                      busStop["longitude"],
                    ),
                    builder: (context) => Container(
                      padding: const EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      alignment: Alignment.center,
                      child: IconButton(
                        icon: Icon(
                          MdiIcons.busStop,
                          size: 15,
                          color: Colors.white,
                        ),
                        onPressed: () => busStopModalSheet(
                          busStop['code'],
                          busStop['description'],
                          busStop['roadName'],
                        ),
                      ),
                    ),
                  ),
                ]
              ],
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: FloatingActionButton.extended(
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: onPressFAB,
            label: (locationServiceEnabled == true) &&
                    (permissionGranted != PermissionStatus.deniedForever) &&
                    (permissionGranted != PermissionStatus.denied)
                ? nearbyBusStopBool
                    ? Text(
                        'ALL',
                        style: TextStyle(
                          color: Theme.of(context).appBarTheme.color,
                        ),
                      )
                    : Text(
                        'NEARBY',
                        style: TextStyle(
                          color: Theme.of(context).appBarTheme.color,
                        ),
                      )
                : Text('NEARBY'),
            icon: (locationServiceEnabled == true) &&
                    (permissionGranted.toString() !=
                        "PermissionStatus.deniedForever") &&
                    (permissionGranted.toString() != "PermissionStatus.denied")
                ? nearbyBusStopBool
                    ? Icon(MdiIcons.busStop)
                    : Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(math.pi),
                        child: Icon(FluentIcons.cursor_24_filled),
                      )
                : Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(math.pi),
                    child: Icon(FluentIcons.cursor_24_filled),
                  ),
          ),
        )
      ],
    );
  }
}
