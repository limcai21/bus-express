import 'package:bus_express/model/custom_icons_icons.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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
        return MdiIcons.seatPassenger;
      }
      break;
    case "SDA":
      {
        return MdiIcons.walk;
      }
      break;
    case "LSD":
      {
        return FluentIcons.important_24_filled;
      }
      break;
    case "WAB":
      {
        return MdiIcons.wheelchairAccessibility;
      }
      break;
    case "SD":
      {
        return MdiIcons.busSide;
      }
      break;
    case "BD":
      {
        return MdiIcons.busArticulatedEnd;
      }
      break;
    case "DD":
      {
        return MdiIcons.busDoubleDecker;
      }
      break;
    default:
      {
        return MdiIcons.bus;
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
