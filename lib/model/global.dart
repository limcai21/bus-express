import 'dart:math';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:latlong/latlong.dart';

Map<String, dynamic> allBusStopsData = {};
Map<String, dynamic> nearbyBusStopsData = {};
Map<String, dynamic> allBusServiceData = {};
Map<String, dynamic> allBusRouteData = {};
Map<String, dynamic> allAddressData = {};

List allBusServiceType = [];
List<String> filters = <String>[];

bool locationServiceEnabled;
bool isUserLogin = false;
bool isAllPermissionEnabled = false;
bool isThereInternetConnection = false;

String searchQuery = '';
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

formatBusCategory(String category) {
  var finalCategory = category.replaceAll('_', ' ');
  finalCategory = finalCategory.capitalizeFirstLetter();
  return finalCategory;
}

double calculateDistance(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 -
      c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  return 1000 * 12742 * asin(sqrt(a));
}

extension StringExtension on String {
  String capitalizeFirstLetter() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
