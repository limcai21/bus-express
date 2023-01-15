import 'package:flutter/material.dart';
import 'package:bus_express/model/global.dart';
import 'package:bus_express/view/search/search.dart';
import './customSearchTabBar.dart';

class DataSearch extends SearchDelegate<String> {
  busStopSearching() {
    Map<String, dynamic> tempSearchHolderForBusStop = {};

    allBusStopsData.forEach((key, value) {
      final description = (value["description"]).toString();
      final code = (value["code"]).toString();

      if (((description.toUpperCase()).contains(query.toUpperCase())) ||
          ((code.toUpperCase()).contains(query))) {
        tempSearchHolderForBusStop[key] = value;
      }
    });

    if (tempSearchHolderForBusStop.length == 0) {
      tempSearchHolderForBusStop["error"] = {
        "error": true,
        "description": "No Result",
        "code": "Maybe there's a typo?"
      };
    }

    return tempSearchHolderForBusStop;
  }

  busServiceSearching() {
    Map<String, dynamic> tempSearchHolderForBusService = {};

    allBusServiceData.forEach((key, value) {
      final service = (value["serviceNo"]).toString();

      if ((service.toString()).contains(query.toUpperCase())) {
        tempSearchHolderForBusService[key] = value;
      }
    });

    if (tempSearchHolderForBusService.length == 0) {
      tempSearchHolderForBusService["error"] = {
        "error": true,
        "serviceNo": "No Result",
        "operator": "Maybe there's a typo?"
      };
    }

    return tempSearchHolderForBusService;
  }

  addressSearching() {
    Map<String, dynamic> tempSearchHolderForAddress = {};

    allAddressData.forEach((key, value) {
      final roadName = (value["roadName"]).toString();

      if ((roadName.toUpperCase()).contains(query.toUpperCase())) {
        tempSearchHolderForAddress[key] = value;
      }
    });

    if (tempSearchHolderForAddress.length == 0) {
      tempSearchHolderForAddress["error"] = {
        "error": true,
        "roadName": "No Result",
        "subtitle": "Maybe there's a typo?"
      };
    }
    return tempSearchHolderForAddress;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear_rounded),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        searchBusStopsData = allBusStopsData;
        searchBusServiceData = allBusServiceData;
        searchAddressData = allAddressData;
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      searchBusStopsData = allBusStopsData;
      searchBusServiceData = allBusServiceData;
      searchAddressData = allAddressData;
    } else {
      searchBusStopsData = busStopSearching();
      searchBusServiceData = busServiceSearching();
      searchAddressData = addressSearching();
    }
    return CustomSearchTabBar();
  }
}
