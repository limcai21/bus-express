import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

// COLORS
// const primaryColor = Colors.blue;
const primaryColor = Color.fromRGBO(0, 46, 83, 1);

// FORM
// USERNAME
const usernameEmptyNull = 'Username cannot be empty';
const usernameExist = 'Username exist. Please choose a new one';
const usernameUpdateTitle = 'Updated!';

// EMAIL
const emailEmptyNull = 'Email cannot be empty';
const emailInvalid = 'Email is not valid';
const emailRegex =
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
const emailUpdateTitle = 'Updated!';
const emailUpdateDescription = "Email updated!";

// PASSWORD
const passwordEmptyNull = 'Password cannot be empty';
const retpyePasswordEmptyNull = 'Retype Password cannot be empty';
const passwordAndRetypePasswordDifferent =
    'Password & Retype Password must match';

// NEW PASSWORD
const currentPasswordEmptyNull = 'Current Password cannot be empty';
const newPasswordEmptyNull = 'New Password cannot be empty';
const retpyeNewPasswordEmptyNull = 'Retype New Password cannot be empty';
const newPasswordAndRetypeNewPasswordDifferent =
    'New Password & Retype New Password must match';
const passwordChangedTitle = 'Password Changed!';
const passwordChangedDescription = 'You will are now logout.\nPlease sign in';
const currentPasswordIncorrect = 'Current Password incorrect';

// CONTACT NUMBER
const contactNumberEmptyNull = 'Contact Number cannot be empty';
const contactNumberInvalid = 'Contact Number invalid';
const contactNumberRegex = r'^(?:6|8|9)[0-9]{7}$';
const contactNumberUpdateTitle = 'Updated!';
const contactNumberUpdateDescription = "Your contact number is updated!";
const contactNumberMaxLength = 8;

// LOGIN FAIL
const loginFailTitle = "Error";
const loginFailDescription = "Invalid Username or Password";

// ALERT
// ALL BUS STOP
const zoomOutToViewMapTitle = "Limited Features";
const zoomOutToViewMap =
    'Your location permission are disabled.\nPlease zoom out to view all the bus stops';

// PERMISSION DISABLED
const permissionDisabledTitle = "Location Service Disabled";
const permissionDisabled =
    'Please allow location service and permission to use this feature';

// DELETE ACCOUNT
const deleteAccountTitle = "Delete Account";
const deleteAccountDescription =
    "Are you sure you want to delete your account?";

// LOGOUT
const logoutTitle = 'Logout';
const logoutDescription = "Are you sure you want to logout?";

// SAVE BUS STOP
const loginTitle = 'Erm...';
const loginDescription = "Login to favourite this bus stop";

// BUS ROUTE NOT FOUND
const busRouteNotFoundTitle = 'Weird...';
const busRouteNotFoundDescription =
    " bus route is currently not available. \nYou might want to feedback this to us";

// NO BUS STOP IN THIS ROUTE
const noBusStopInThisRouteTitle = 'Oops';
const noBusStopInThisRouteDescription = 'No bus stops along this road';

// MAP
const mapUrlTemplate = 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
const mapSubdomain = ['a', 'b', 'c'];
var mapMaxBound = LatLngBounds(
  LatLng(1.56073, 104.1147),
  LatLng(1.16, 103.502),
);

// BUS
const busNoCoordinateTitle = "Oops!";
const busNoCoordinateDescription = "Bus coordinates are not yet available";

// CANT GET BUS ROUTE FOR THIS BUS STOP
const busRouteNotAvailableForBusStopTitle = "Error";
const busRouteNotAvailableForBusStopDescription =
    "We currently are not able to get the buses operating at this bus stop";

// SWIPE LEFT TO RIGHT BACKGROUND 2
const swipeLeftToRightInstruction = "😆 Swipe Right Instead";

// REFETCH DATA
const refetchDataTitle = "Done!";
const refetchDataDescription = "All Bus Stops, Service & Route are now updated";

// ACCOUNT DELETE
const accountDeletedTitle = "Account Deleted";
const accountDeletedDescription =
    "Tell us what we can do better by sending us a feedback if you don't mind";

// COMPANY INFO
const comapanyName = 'arnet';
const companyNumber = '+65 64515115';
const companyWebsite = 'https://www.arnet.com.sg';
const companyFeedbackEmail = 'feedback@busexpress.com.sg';
const companyDeveloper = 'Lim Cai';
const contactUsActionLines =
    "We'd love to hear from you. Our friendly team is always here to chat";

// API
const ltaDataMallURL = 'https://datamall.lta.gov.sg/content/datamall/en.html';
const stbAPIURL = 'https://tih-dev.stb.gov.sg/';

// APP INFO
const appName = 'Bus Express';
const appSubtitle = 'Make your commute a breeze!';
const appBriefLong =
    'Bus Express is designed by Arnet for commuters in Singapore to check the real-time arrival timing of buses at their desired bus stop. The app is easy to use and provides users with accurate and up-to-date information on bus schedules, routes, and arrival times';
