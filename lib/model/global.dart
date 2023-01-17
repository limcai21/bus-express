import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:latlong/latlong.dart';

Map<String, dynamic> allBusStopsData = {};
Map<String, dynamic> nearbyBusStopsData = {};
Map<String, dynamic> allBusServiceData = {};
Map<String, dynamic> allAddressData = {};

bool locationServiceEnabled;
bool isUserLogin = false;
bool isAllPermissionEnabled = false;
bool isThereInternetConnection = false;

String currentLoginUsername = '';

int searchTabIndex = 0;

PermissionStatus permissionGranted;
Location location = new Location();
LatLng centerPoint = LatLng(1.3521, 103.8198);

listViewHeader(String title, BuildContext context) {
  title = title.toUpperCase();
  return Container(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
    alignment: Alignment.centerLeft,
    child: Text(
      title,
      style: TextStyle(
        fontSize: 12,
        color: Theme.of(context).primaryColor,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

dataTile(IconData icon, MaterialColor mainColor) {
  return Container(
    padding: const EdgeInsets.all(5),
    decoration: BoxDecoration(
      color: mainColor[100],
      borderRadius: BorderRadius.circular(10),
    ),
    child: Icon(
      icon,
      size: 32,
      color: mainColor[600],
    ),
  );
}
