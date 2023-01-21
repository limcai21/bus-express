import 'package:bus_express/model/constants.dart';
import 'package:bus_express/model/global.dart';
import 'package:bus_express/model/switchCase.dart';
import 'package:bus_express/view/components/alert/alertDialog.dart';
import 'package:bus_express/view/components/customScaffold.dart';
import 'package:bus_express/view/search/busArrival/addingAndRemovingFav.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class BusesLocation extends StatelessWidget {
  final String title;
  final String subtitle;
  final Map<String, dynamic> data;
  final String busStopCode;
  final String busStopName;
  BusesLocation(
    this.title,
    this.subtitle,
    this.data,
    this.busStopCode,
    this.busStopName,
  );

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title,
      busStopName + "  -  " + subtitle,
      BusesLocationMap(
        data: data,
        busStopCode: busStopCode,
        busService: title,
        busStopName: busStopName,
      ),
      2,
    );
  }
}

class BusesLocationMap extends StatefulWidget {
  final Map<String, dynamic> data;
  final String busStopCode;
  final String busService;
  final String busStopName;
  BusesLocationMap({
    Key key,
    @required this.data,
    @required this.busStopCode,
    @required this.busService,
    @required this.busStopName,
  }) : super(key: key);

  @override
  State<BusesLocationMap> createState() => _BusesLocationMapState();
}

class _BusesLocationMapState extends State<BusesLocationMap> {
  bool nearbyBusStopBool = true;
  var mapMaker = {};
  double zoom = 15;
  MapController mapController = MapController();
  CenterOnLocationUpdate centerOnLocationUpdate;
  Map<String, dynamic> busArrivalTiming;
  List<Marker> next3BusMarker = [];
  List middlePointOfNext3BusMarker = [];

  initData() async {
    setState(() {
      busArrivalTiming = widget.data;
    });
  }

  busMarker(double lat, double long, String estimatedArrival, int layout) {
    if (layout == 1) {
      // BUS LOCATION
      return new Marker(
        point: new LatLng(lat, long),
        builder: (context) => Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(100),
          ),
          alignment: Alignment.center,
          child: Text(
            estimatedArrival,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      );
    }

    if (layout == 2) {
      // BUS STOP LOCATION
      return new Marker(
        height: 50,
        width: 50,
        point: new LatLng(lat, long),
        builder: (context) => Container(
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 2, color: Colors.black),
            borderRadius: BorderRadius.circular(100),
          ),
          alignment: Alignment.center,
          child: Icon(
            MdiIcons.busStop,
            size: 26,
            color: Colors.black,
          ),
        ),
      );
    }
  }

  simplifyData(String type) {
    final lat = busArrivalTiming[type]['latitude'] != null
        ? double.parse(busArrivalTiming[type]['latitude'])
        : null;
    final long = busArrivalTiming[type]['longitude'] != null
        ? double.parse(busArrivalTiming[type]['longitude'])
        : null;

    final estimatedArrival = busArrivalTiming[type]['estimatedArrival'] != null
        ? (busArrivalTiming[type]['estimatedArrival']).toString()
        : null;

    if (lat != null && long != null) {
      next3BusMarker.add(busMarker(lat, long, estimatedArrival, 1));
      middlePointOfNext3BusMarker.add([lat, long]);
    }
  }

  generateNext3BusMarker() {
    simplifyData("nextBus");
    simplifyData("nextBus2");
    simplifyData("nextBus3");

    final busStopLat = allBusStopsData[widget.busStopCode]['latitude'];
    final busStopLong = allBusStopsData[widget.busStopCode]['longitude'];

    next3BusMarker.add(busMarker(busStopLat, busStopLong, null, 2));

    // final nextBusData = busArrivalTiming['nextBus'];
    // final nextBusLat = double.parse(nextBusData['latitude']);
    // final nextBusLong = double.parse(nextBusData['longitude']);

    setState(() {
      centerPoint = LatLng(busStopLat - 0.004, busStopLong);
    });
  }

  busArrivalCustomCard(
    String title,
    String nextBusArrival,
    IconData nextBusType,
    String feature,
    String feature2,
    double lat,
    double long,
    EdgeInsetsGeometry margin,
  ) {
    return GestureDetector(
      onTap: () {
        if (lat == 0.0 && long == 0.0) {
          alertDialog(
              busNoCoordinateTitle, busNoCoordinateDescription, context);
        } else {
          setState(() {
            mapController.move(LatLng(lat - 0.004, long), 15);
          });
        }
      },
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(20),
        margin: margin,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 10,
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TITLE and BUS TYPE
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      nextBusArrival,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    nextBusType,
                    size: 24,
                    color: Colors.blue[600],
                  ),
                )
              ],
            ),
            SizedBox(height: 20),
            // FEATURES
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Features:",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                SizedBox(height: 5),
                Wrap(
                  spacing: 3,
                  runSpacing: 3,
                  children: [
                    legendPill(busFeaturesColor(feature),
                        busFeaturesWord(feature), busFeaturesIcon(feature)),
                    if (feature2 != null)
                      legendPill(busFeaturesColor(feature2),
                          busFeaturesWord(feature2), busFeaturesIcon(feature2)),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initData();
    generateNext3BusMarker();
  }

  @override
  Widget build(BuildContext context) {
    // NEXT BUS
    final nextBusData = busArrivalTiming['nextBus'];
    final nextBusArrival = nextBusData['estimatedArrival'] != 'Arr'
        ? 'Arriving in ' + nextBusData['estimatedArrival'].toString() + " min"
        : "Arriving";
    final nextBusType = busFeaturesIcon(nextBusData['type'].toString());
    final nextBusLoad = nextBusData['load'];
    final nextBusFeature = nextBusData['feature'];
    final nextBusLat = nextBusData['latitude'] != null
        ? double.parse(nextBusData['latitude'])
        : 0.0;
    final nextBusLong = nextBusData['longitude'] != null
        ? double.parse(nextBusData['longitude'])
        : 0.0;

    // NEXT BUS 2
    final nextBus2Data = busArrivalTiming['nextBus2'];
    final nextBus2Arrival = nextBus2Data['estimatedArrival'] != 'Arr'
        ? 'Arriving in ' + nextBus2Data['estimatedArrival'].toString() + " min"
        : "Arriving";
    final nextBus2Type = busFeaturesIcon(nextBus2Data['type'].toString());
    final nextBus2Load = nextBus2Data['load'];
    final nextBus2Feature = nextBus2Data['feature'];
    final nextBus2Lat = nextBus2Data['latitude'] != null
        ? double.parse(nextBus2Data['latitude'])
        : 0.0;
    final nextBus2Long = nextBus2Data['longitude'] != null
        ? double.parse(nextBus2Data['longitude'])
        : 0.0;

    // NEXT BUS 3
    final nextBus3Data = busArrivalTiming['nextBus3'];
    final nextBus3Arrival = nextBus3Data['estimatedArrival'] != 'Arr'
        ? 'Arriving in ' + nextBus3Data['estimatedArrival'].toString() + " min"
        : "Arriving";
    final nextBus3Type = busFeaturesIcon(nextBus3Data['type'].toString());
    final nextBus3Load = nextBus3Data['load'];
    final nextBus3Feature = nextBus3Data['feature'];
    final nextBus3Lat = nextBus3Data['latitude'] != null
        ? double.parse(nextBus3Data['latitude'])
        : 0.0;
    final nextBus3Long = nextBus3Data['longitude'] != null
        ? double.parse(nextBus3Data['longitude'])
        : 0.0;

    return Stack(
      alignment: Alignment.bottomCenter,
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
            new MarkerLayerOptions(markers: next3BusMarker),
          ],
        ),
        Container(
          height: 210,
          color: Color.fromRGBO(0, 0, 0, 0.5),
          child: ListView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: [
              if (middlePointOfNext3BusMarker.length >= 1 &&
                  middlePointOfNext3BusMarker.length <= 3)
                busArrivalCustomCard(
                  "Next Bus",
                  nextBusArrival,
                  nextBusType,
                  nextBusLoad,
                  nextBusFeature,
                  nextBusLat,
                  nextBusLong,
                  middlePointOfNext3BusMarker.length == 1
                      ? const EdgeInsets.all(20)
                      : const EdgeInsets.fromLTRB(20, 20, 5, 20),
                ),
              if (middlePointOfNext3BusMarker.length >= 2 &&
                  middlePointOfNext3BusMarker.length <= 3)
                busArrivalCustomCard(
                  "Next Bus 2",
                  nextBus2Arrival,
                  nextBus2Type,
                  nextBus2Load,
                  nextBus2Feature,
                  nextBus2Lat,
                  nextBus2Long,
                  middlePointOfNext3BusMarker.length == 2
                      ? const EdgeInsets.fromLTRB(5, 20, 20, 20)
                      : const EdgeInsets.fromLTRB(5, 20, 5, 20),
                ),
              if (middlePointOfNext3BusMarker.length == 3)
                busArrivalCustomCard(
                  "Next Bus 3",
                  nextBus3Arrival,
                  nextBus3Type,
                  nextBus3Load,
                  nextBus3Feature,
                  nextBus3Lat,
                  nextBus3Long,
                  const EdgeInsets.fromLTRB(5, 20, 20, 20),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
