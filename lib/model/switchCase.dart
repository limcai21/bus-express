import 'package:bus_express/custom_icons_icons.dart';
import 'package:flutter/material.dart';

operatorName(operator) {
  switch (operator) {
    case "SBST":
      {
        return "SBS Transit";
      }
      break;
    case "SMRT":
      {
        return "SMRT Corporation";
      }
      break;
    case "TTS":
      {
        return "Tower Transit Singapore";
      }
      break;
    case "GAS":
      {
        return "Go Ahead Singapore";
      }
      break;
  }
}

busFeaturesIcon(feature) {
  switch (feature) {
    case "SEA":
      {
        return CustomIcons.seat;
      }
      break;
    case "SDA":
      {
        return CustomIcons.standing;
      }
      break;
    case "LSD":
      {
        return CustomIcons.important;
      }
      break;
    case "WAB":
      {
        return CustomIcons.wheelchair;
      }
      break;
    case "SD":
      {
        return CustomIcons.bus_single_decker;
      }
      break;
    case "BD":
      {
        return CustomIcons.bus_bendy;
      }
      break;
    case "DD":
      {
        return CustomIcons.bus_double_decker;
      }
      break;
  }
}

busFeaturesWord(feature) {
  switch (feature) {
    case "SEA":
      {
        return "Seating Available";
      }
      break;
    case "SDA":
      {
        return 'Standing Available';
      }
      break;
    case "LSD":
      {
        return "Limited Standing";
      }
      break;
    case "WAB":
      {
        return "Wheelchair Accessible";
      }
      break;
    case "SD":
      {
        return "Single Deck";
      }
      break;
    case "DD":
      {
        return "Double Deck";
      }
      break;
    case "BD":
      {
        return "Bendy";
      }
      break;
  }
}

busFeaturesColor(feature) {
  switch (feature) {
    case "SEA":
      {
        return Colors.green;
      }
      break;
    case "SDA":
      {
        return Colors.orange;
      }
      break;
    case "LSD":
      {
        return Colors.red;
      }
      break;
    case "WAB":
      {
        return Colors.grey[700];
      }
      break;
    case "SD":
      {
        return Colors.purple;
      }
      break;
    case "DD":
      {
        return Colors.brown;
      }
      break;
    case "BD":
      {
        return Colors.teal;
      }
      break;
    default:
      {
        return Colors.grey;
      }
      break;
  }
}
