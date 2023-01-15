import 'dart:collection';
import 'package:bus_express/model/api.dart';
import 'package:bus_express/model/global.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';

// GET USER CURRENT LOCATION
checkLocationServiceAndPermission() async {
  print("");
  print("Waiting for Permission and Location Service...");
  locationServiceEnabled = await location.serviceEnabled();
  if (!locationServiceEnabled) {
    locationServiceEnabled = await location.requestService();

    if (!locationServiceEnabled) {
      // LOCATION SERVICE NOT ENABLED
    }
  }

  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      // PERMISSION NOT GRANTED
    }
  }

  print("");
  print("locationServiceEnabled: " + locationServiceEnabled.toString());
  print(permissionGranted);
  print("");
}

// GET NEARBY BUS STOP
nearbyBusStop() async {
  if ((locationServiceEnabled == true) &&
      (permissionGranted.toString() != "PermissionStatus.denied") &&
      (permissionGranted.toString() != "PermissionStatus.deniedForever")) {
    await location.getLocation().then((value) async {
      var lat = value.latitude;
      var long = value.longitude;
      centerPoint = LatLng(lat, long);
      nearbyBusStopsData = {};
      nearbyBusStopsData = await BusStop().nearby(lat, long);
      print("Nearby bus stops loaded");
    });
  } else {
    print("Unable to load nearby bus stops due to location service/permission");
  }
}

// GET NEARBY BUS STOP
startUpLoadData(context) async {
  // loadingAlert(context);

  print("Loading (startUpLoadData)");
  allBusStopsData = await BusStop().all();
  allBusServiceData = await Bus().all();

  // GET ROADNAME FOR ADDRESS
  Map<String, dynamic> tempHolder = {};
  allBusStopsData.forEach((key, value) {
    final roadName = value['roadName'];

    if (tempHolder[roadName] != null) {
      tempHolder[roadName] = {
        "roadName": roadName,
        "amountOfBusStop": (tempHolder[roadName]['amountOfBusStop'] + 1)
      };
    } else {
      tempHolder[roadName] = {
        "roadName": roadName,
        "amountOfBusStop": 1,
      };
    }
  });

  // SORT BY A-Z
  allBusStopsData = new SplayTreeMap<String, dynamic>.from(
      allBusStopsData, (k1, k2) => k1.compareTo(k2));
  allBusServiceData = new SplayTreeMap<String, dynamic>.from(
      allBusServiceData, (k1, k2) => k1.compareTo(k2));
  allAddressData = new SplayTreeMap<String, dynamic>.from(
      tempHolder, (k1, k2) => k1.compareTo(k2));

  print("Data all loaded (startUpLoadData)");

  // REMOVE LOADING ALERT
  // Navigator.of(context).pop();
}
