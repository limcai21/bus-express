import 'dart:math';

import 'package:bus_express/model/constants.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:latlong/latlong.dart';
import 'dart:math' as math;

import 'package:shared_preferences/shared_preferences.dart';

Map<String, dynamic> allBusStopsData = {};
Map<String, dynamic> nearbyBusStopsData = {};
Map<String, dynamic> allBusServiceData = {};
Map<String, dynamic> allBusRouteData = {};
Map<String, dynamic> allAddressData = {};

List allBusServiceType = [];

bool locationServiceEnabled;
bool isUserLogin = false;
bool isAllPermissionEnabled = false;
bool isThereInternetConnection = false;

String searchQuery = '';
String currentLoginUsername = '';
String userContactNumber = '';

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

customListTile(
  String title,
  String subtitle,
  IconData icon,
  IconData trailingIcon,
  MaterialColor bgColor,
  Function onTap, {
  double borderRadius,
  double iconSize,
  double padding,
  bool rotate = false,
}) {
  return ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
    title: Text(
      title,
      style: TextStyle(fontWeight: FontWeight.w500),
    ),
    subtitle: subtitle != null ? Text(subtitle) : null,
    trailing: trailingIcon != null ? Icon(trailingIcon, size: 18) : null,
    leading: customLeadingIcon(
      icon,
      bgColor,
      iconSize: iconSize,
      borderRadius: borderRadius,
      padding: padding,
      rotate: rotate,
    ),
    onTap: onTap != null ? onTap : null,
  );
}

customLeadingIcon(
  IconData icon,
  Color mainColor, {
  double borderRadius,
  double iconSize,
  double padding,
  bool rotate,
}) {
  // CHECK IF IS FROM PROFILE
  Color iconColor = mainColor;
  bool fromProfile = false;
  Widget iconOutput;

  if (borderRadius != null && iconSize != null && padding != null) {
    iconColor = Colors.white;
    fromProfile = true;
  }

  if (rotate == null) {
    rotate = false;
  }

  if (rotate) {
    iconOutput = Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationY(math.pi),
      child: Icon(
        icon,
        size: iconSize != null ? iconSize : 32,
        color: iconColor,
      ),
    );
  } else {
    iconOutput = Icon(
      icon,
      size: iconSize != null ? iconSize : 32,
      color: iconColor,
    );
  }

  return Container(
    padding: EdgeInsets.all(padding != null ? padding : 5),
    decoration: BoxDecoration(
      color: fromProfile ? mainColor : Color.lerp(Colors.white, mainColor, 0.2),
      borderRadius: BorderRadius.circular(
        borderRadius != null ? borderRadius : 10,
      ),
    ),
    child: iconOutput,
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

checkUsernameExist(String username, SharedPreferences prefs) {
  final checkUsername = prefs.getString(username);
  if (checkUsername != null) {
    return usernameExist;
  } else {
    return null;
  }
}

extension StringExtension on String {
  String capitalizeFirstLetter() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
