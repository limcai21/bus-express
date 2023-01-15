import 'package:flutter/material.dart';
import 'package:bus_express/model/global.dart';
import 'components/customSearchTabBar.dart';

class Search extends StatefulWidget {
  @override
  State<Search> createState() => _SearchState();
}

Map<String, dynamic> searchBusStopsData = {};
Map<String, dynamic> searchBusServiceData = {};
Map<String, dynamic> searchAddressData = {};

class _SearchState extends State<Search> {
  @override
  void initState() {
    super.initState();
    searchBusStopsData = allBusStopsData;
    searchBusServiceData = allBusServiceData;
    searchAddressData = allAddressData;
  }

  @override
  Widget build(BuildContext context) {
    return CustomSearchTabBar();
  }
}
