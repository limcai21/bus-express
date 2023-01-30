import 'dart:convert';
import 'dart:collection';
import 'package:bus_express/view/components/alert/alertLoading.dart';
import 'package:flutter/cupertino.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:bus_express/model/api.dart';
import 'package:bus_express/model/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

// GET USER CURRENT LOCATION
checkLocationServiceAndPermission() async {
  bool checkLocationService = true;
  bool checkPermissionGranted = true;
  print("");
  print("Waiting for Permission and Location Service...");
  locationServiceEnabled = await location.serviceEnabled();
  if (!locationServiceEnabled) {
    locationServiceEnabled = await location.requestService();

    if (!locationServiceEnabled) {
      // LOCATION SERVICE NOT ENABLED
      print("LOCATION SERVICE NOT ENABLED");
      checkLocationService = false;
    }
  }

  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      // PERMISSION NOT GRANTED
      print("PERMISSION NOT GRANTED");
      checkPermissionGranted = false;
    }
  }

  if (checkLocationService && checkPermissionGranted) {
    print("both enabled");
    isAllPermissionEnabled = true;
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

      print("Current Position: " + lat.toString() + ", " + long.toString());
      print("Nearby bus stops loaded");
    });
  } else {
    print("Unable to load nearby bus stops due to location service/permission");
  }
}

// GET NEARBY BUS STOP
startUpLoadData(context) async {
  print("Loading (startUpLoadData)");

  // GETTING DATA FROM DB
  final prefs = await SharedPreferences.getInstance();
  bool showAlert = false;

  // FOR TESTING
  // await prefs.remove('allBusStopsData');
  // await prefs.remove('allBusServiceData');
  // await prefs.remove('allBusRouteData');

  final String dbBusStopsData = prefs.getString('allBusStopsData');
  final String dbBusServiceData = prefs.getString('allBusServiceData');
  final String dbBusRouteData = prefs.getString('allBusRouteData');

  if (dbBusStopsData == null &&
      dbBusServiceData == null &&
      dbBusRouteData == null) {
    loadingAlert(context, title: "Loading required data");
    showAlert = true;
  }

  // BUS STOP
  if (dbBusStopsData == null) {
    await BusStop().all();
  } else {
    allBusStopsData = jsonDecode(dbBusStopsData);
  }

  // BUS SERVICE
  if (dbBusServiceData == null) {
    await Bus().all();
  } else {
    allBusServiceData = jsonDecode(dbBusServiceData);
  }

  // BUS ROUTE
  if (dbBusRouteData == null) {
    await Bus().route();
  } else {
    allBusRouteData = jsonDecode(dbBusRouteData);
  }

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

  // GET BUS TYPE
  allBusServiceData.forEach((key, value) {
    String category = formatBusCategory(value['category']);
    if (!allBusServiceType.contains(category)) {
      allBusServiceType.add(category);
    }
  });

  // SORT BY A-Z
  allBusStopsData = new SplayTreeMap<String, dynamic>.from(
      allBusStopsData, (k1, k2) => k1.compareTo(k2));
  allBusServiceData = new SplayTreeMap<String, dynamic>.from(
      allBusServiceData, (k1, k2) => k1.compareTo(k2));
  allAddressData = new SplayTreeMap<String, dynamic>.from(
      tempHolder, (k1, k2) => k1.compareTo(k2));

  if (showAlert) {
    Navigator.pop(context);
  }

  print("Data all loaded (startUpLoadData)");
}
