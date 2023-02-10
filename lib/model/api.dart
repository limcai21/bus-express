import 'dart:collection';
import 'dart:convert';
import 'package:bus_express/model/switchCase.dart';
import 'package:http/http.dart' as http;
import 'package:bus_express/model/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

// LTA DATAMALL
// API KEY = mDsTHNRhT3aj8d9FamUH3A==
final allBusRouteURL =
    'http://datamall2.mytransport.sg/ltaodataservice/BusRoutes';
final allBusServiceURL =
    'http://datamall2.mytransport.sg/ltaodataservice/BusServices';
final busArrivalURL =
    'http://datamall2.mytransport.sg/ltaodataservice/BusArrivalv2'; // Allow ?BusStopCode=59739&ServiceNo=805
final allBusStopsURL =
    "http://datamall2.mytransport.sg/ltaodataservice/BusStops";

final ltaDatamallAPIHeader = {
  'AccountKey': 'mDsTHNRhT3aj8d9FamUH3A==',
  'accept': 'application/json',
};

class Bus {
  Future<Object> service(String busStopCode) async {
    var request = http.Request(
      'GET',
      Uri.parse(busArrivalURL + "?BusStopCode=$busStopCode"),
    );
    request.headers.addAll(ltaDatamallAPIHeader);
    var response = await request.send();

    if (response.statusCode == 200) {
      List data = jsonDecode(await response.stream.bytesToString())['Services'];
      print(data);
      var tempBusHolder = [];
      for (var busService in data) {
        tempBusHolder.add(busService['ServiceNo']);
      }

      tempBusHolder.sort();
      return tempBusHolder.toSet().toList();
    } else {
      return [response.reasonPhrase];
    }
  }

  Future<Object> serviceOperator(String busStopCode, String busService) async {
    var request = http.Request(
      'GET',
      Uri.parse(
          busArrivalURL + "?BusStopCode=$busStopCode&ServiceNo=$busService"),
    );
    request.headers.addAll(ltaDatamallAPIHeader);
    var response = await request.send();

    if (response.statusCode == 200) {
      List data = jsonDecode(await response.stream.bytesToString())['Services'];
      for (var busServiceData in data) {
        if (busServiceData['ServiceNo'] == busService) {
          return operatorName(busServiceData['Operator']);
        } else {
          return '';
        }
      }
    }
    return '';
  }

  route({
    Map<String, dynamic> busRouteData,
    int skip = 0,
  }) async {
    final url = allBusRouteURL + "?\$skip=$skip";
    var request = http.Request('GET', Uri.parse(url));
    request.headers.addAll(ltaDatamallAPIHeader);
    var response = await request.send();
    int counter = 0;

    if (response.statusCode == 200) {
      final List data =
          jsonDecode(await response.stream.bytesToString())['value'];

      if (data.length > 0) {
        for (var busRoute in data) {
          final serviceNo = (busRoute['ServiceNo']).toString();
          final busOperator = operatorName(busRoute['Operator']);
          final sequence = (busRoute['StopSequence']).toString();
          final busStopCode = (busRoute['BusStopCode']).toString();
          final direction = busRoute['Direction'];
          final distance = busRoute['Distance'];
          final weekdaysFirst = busRoute['WD_FirstBus'];
          final weekdaysLast = busRoute['WD_LastBus'];
          final saturdayFirst = busRoute['SAT_FirstBus'];
          final saturdayLast = busRoute['SAT_LastBus'];
          final sundayFirst = busRoute['SUN_FirstBus'];
          final sundayLast = busRoute['SUN_LastBus'];

          // INIT
          if (busRouteData == null) {
            busRouteData = {};
          }

          if (busRouteData[serviceNo] == null) {
            busRouteData[serviceNo] = {};
          }

          if (direction == 1) {
            if (busRouteData[serviceNo]['Direction 1'] == null) {
              counter = 0;
              busRouteData[serviceNo]['Direction 1'] = {};
            }

            busRouteData[serviceNo]['Direction 1'][counter.toString()] = {
              "serviceNo": serviceNo,
              "busOperator": busOperator,
              "sequence": sequence,
              'roadName': allBusStopsData[busStopCode] == null
                  ? ''
                  : allBusStopsData[busStopCode]['roadName'],
              'busStopName': allBusStopsData[busStopCode] == null
                  ? ''
                  : allBusStopsData[busStopCode]['description'],
              'busStopCode': busStopCode,
              "distance": distance,
              "weekdaysFirst": weekdaysFirst,
              "weekdaysLast": weekdaysLast,
              "saturdayFirst": saturdayFirst,
              "saturdayLast": saturdayLast,
              "sundayFirst": sundayFirst,
              "sundayLast": sundayLast,
            };
          } else {
            if (busRouteData[serviceNo]['Direction 2'] == null) {
              busRouteData[serviceNo]['Direction 2'] = {};
              counter = 0;
            }

            busRouteData[serviceNo]['Direction 2'][counter.toString()] = {
              "serviceNo": serviceNo,
              "busOperator": busOperator,
              "sequence": sequence,
              'roadName': allBusStopsData[busStopCode] == null
                  ? ''
                  : allBusStopsData[busStopCode]['roadName'],
              'busStopName': allBusStopsData[busStopCode] == null
                  ? ''
                  : allBusStopsData[busStopCode]['description'],
              'busStopCode': busStopCode,
              "distance": distance,
              "weekdaysFirst": weekdaysFirst,
              "weekdaysLast": weekdaysLast,
              "saturdayFirst": saturdayFirst,
              "saturdayLast": saturdayLast,
              "sundayFirst": sundayFirst,
              "sundayLast": sundayLast,
            };
          }
          counter++;
        }

        // GET NEXT LIST
        await Bus().route(skip: skip + 500, busRouteData: busRouteData);
      }

      // STORE
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('allBusRouteData');
      await prefs.setString('allBusRouteData', jsonEncode(busRouteData));
      allBusRouteData = busRouteData;

      return busRouteData;
    }
  }

  all() async {
    var request = http.Request('GET', Uri.parse(allBusServiceURL));
    request.headers.addAll(ltaDatamallAPIHeader);
    var response = await request.send();
    var tempHolder = [];
    Map<String, dynamic> tempData = {};

    if (response.statusCode == 200) {
      final data = jsonDecode(await response.stream.bytesToString())['value'];
      if (data.length > 0) {
        tempHolder.addAll(data);
      }

      for (var i = 0; i < tempHolder.length; i++) {
        final serviceNo = tempHolder[i]["ServiceNo"];
        var operator = tempHolder[i]["Operator"];
        tempData[serviceNo] = {
          "serviceNo": tempHolder[i]["ServiceNo"],
          "operator": operatorName(operator),
          "category": formatBusCategory(tempHolder[i]["Category"]),
        };
      }

      // STORE
      final prefs = await SharedPreferences.getInstance();
      tempData = new SplayTreeMap<String, dynamic>.from(
          tempData, (k1, k2) => k1.compareTo(k2));
      await prefs.remove('allBusServiceData');
      await prefs.setString('allBusServiceData', jsonEncode(tempData));
      allBusServiceData = tempData;

      return tempData;
    }
  }

  arrival(String busStopCode, {String busService}) async {
    var query = '';
    busService != null
        ? query = '?BusStopCode=$busStopCode&ServiceNo=$busService'
        : query = '?BusStopCode=$busStopCode';
    var request = http.Request('GET', Uri.parse(busArrivalURL + query));
    request.headers.addAll(ltaDatamallAPIHeader);
    var response = await request.send();

    if (response.statusCode == 200) {
      var tempBusArrivalHolder = [];
      Map<String, dynamic> returnData = {};

      final data =
          jsonDecode(await response.stream.bytesToString())['Services'];

      if (data.length > 0) {
        for (var i = 0; i < data.length; i++) {
          tempBusArrivalHolder = data;
        }
      }

      // CHANGE SOME DATA;
      for (var i = 0; i < tempBusArrivalHolder.length; i++) {
        final busService = tempBusArrivalHolder[i]['ServiceNo'];
        var operator = operatorName(tempBusArrivalHolder[i]['Operator']);
        final timeNow = DateTime.now();

        // NEXT BUS
        final nextBus = tempBusArrivalHolder[i]['NextBus'];
        var originCode,
            destinationCode,
            estimatedArrival,
            latitude,
            longitude,
            load,
            feature,
            type;

        if (nextBus.length > 0) {
          originCode =
              nextBus['OriginCode'].isNotEmpty ? nextBus['OriginCode'] : null;
          destinationCode = nextBus['DestinationCode'].isNotEmpty
              ? nextBus['DestinationCode']
              : null;

          if (nextBus['EstimatedArrival'].isNotEmpty) {
            estimatedArrival = DateTime.parse(nextBus['EstimatedArrival'])
                .difference(timeNow)
                .inMinutes;

            if (estimatedArrival <= 0) {
              estimatedArrival = "Arr";
            }
          } else {
            estimatedArrival = "NA";
          }
          latitude =
              nextBus['Latitude'].isNotEmpty ? nextBus['Latitude'] : null;
          longitude =
              nextBus['Longitude'].isNotEmpty ? nextBus['Longitude'] : null;
          load = nextBus['Load'].isNotEmpty ? nextBus['Load'] : null;
          feature = nextBus['Feature'].isNotEmpty ? nextBus['Feature'] : null;
          type = nextBus['Type'].isNotEmpty ? nextBus['Type'] : null;
        }

        // NEXT BUS 2
        final nextBus2 = tempBusArrivalHolder[i]['NextBus2'];
        var estimatedArrival2, latitude2, longitude2, load2, feature2, type2;

        if (nextBus2.length > 0) {
          if (nextBus2['EstimatedArrival'].isNotEmpty) {
            estimatedArrival2 = DateTime.parse(nextBus2['EstimatedArrival'])
                .difference(timeNow)
                .inMinutes;

            if (estimatedArrival2 <= 0) {
              estimatedArrival2 = "Arr";
            }
          } else {
            estimatedArrival2 = "NA";
          }
          latitude2 =
              nextBus2['Latitude'].isNotEmpty ? nextBus2['Latitude'] : null;
          longitude2 =
              nextBus2['Longitude'].isNotEmpty ? nextBus2['Longitude'] : null;
          load2 = nextBus2['Load'].isNotEmpty ? nextBus2['Load'] : null;
          feature2 =
              nextBus2['Feature'].isNotEmpty ? nextBus2['Feature'] : null;
          type2 = nextBus2['Type'].isNotEmpty ? nextBus2['Type'] : null;
        }

        // NEXT BUS 3
        final nextBus3 = tempBusArrivalHolder[i]['NextBus3'];
        var estimatedArrival3, latitude3, longitude3, load3, feature3, type3;

        if (nextBus3.length > 0) {
          if (nextBus3['EstimatedArrival'].isNotEmpty) {
            estimatedArrival3 = DateTime.parse(nextBus3['EstimatedArrival'])
                .difference(timeNow)
                .inMinutes;

            if (estimatedArrival3 <= 0) {
              estimatedArrival3 = "Arr";
            }
          } else {
            estimatedArrival3 = "NA";
          }
          latitude3 =
              nextBus3['Latitude'].isNotEmpty ? nextBus3['Latitude'] : null;
          longitude3 =
              nextBus3['Longitude'].isNotEmpty ? nextBus3['Longitude'] : null;
          load3 = nextBus3['Load'].isNotEmpty ? nextBus3['Load'] : null;
          feature3 =
              nextBus3['Feature'].isNotEmpty ? nextBus3['Feature'] : null;
          type3 = nextBus3['Type'].isNotEmpty ? nextBus3['Type'] : null;
        }

        returnData[busService] = {
          "busService": busService,
          "operator": operator,
          "originCode": originCode,
          "originName": allBusStopsData[originCode] == null
              ? ''
              : allBusStopsData[originCode]['description'],
          "destinationCode": destinationCode,
          "destinationName": allBusStopsData[destinationCode] == null
              ? ''
              : allBusStopsData[destinationCode]['description'],
          "nextBus": {
            "estimatedArrival": estimatedArrival,
            "latitude": latitude,
            "longitude": longitude,
            "load": load,
            "feature": feature,
            "type": type,
          },
          "nextBus2": {
            "estimatedArrival": estimatedArrival2,
            "latitude": latitude2,
            "longitude": longitude2,
            "load": load2,
            "feature": feature2,
            "type": type2,
          },
          "nextBus3": {
            "estimatedArrival": estimatedArrival3,
            "latitude": latitude3,
            "longitude": longitude3,
            "load": load3,
            "feature": feature3,
            "type": type3,
          }
        };
      }

      return returnData;
    }
  }
}

class BusStop {
  all({
    Map<String, dynamic> tempBusStopData,
    int skip = 0,
    List tempHolder,
  }) async {
    var request =
        http.Request('GET', Uri.parse(allBusStopsURL + "?\$skip=$skip"));
    request.headers.addAll(ltaDatamallAPIHeader);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final data = jsonDecode(await response.stream.bytesToString())['value'];
      if (data.length > 0) {
        if (tempHolder == null) {
          tempHolder = [];
        }
        tempHolder.addAll(data);

        for (var i = 0; i < tempHolder.length; i++) {
          if (tempBusStopData == null) {
            tempBusStopData = {};
          }

          var data = tempHolder[i];

          final code = data["BusStopCode"].toString();
          tempBusStopData[code] = {
            "code": code,
            "roadName": data["RoadName"],
            "description": data["Description"],
            "latitude": data["Latitude"],
            "longitude": data["Longitude"],
          };
        }

        await BusStop().all(
          skip: skip + 500,
          tempHolder: tempHolder,
          tempBusStopData: tempBusStopData,
        );
      }
    }

    // STORE
    final prefs = await SharedPreferences.getInstance();
    tempBusStopData = new SplayTreeMap<String, dynamic>.from(
        tempBusStopData, (k1, k2) => k1.compareTo(k2));
    await prefs.remove('allBusStopsData');
    await prefs.setString('allBusStopsData', jsonEncode(tempBusStopData));
    allBusStopsData = tempBusStopData;
  }

  Future<Object> nearby(double lat, double long) async {
    if (allBusServiceData == null) {
      await BusStop().all();
    }

    Map<String, dynamic> tempHolder = {};
    allBusStopsData.forEach((key, value) {
      final busStopLat = value['latitude'];
      final busStopLong = value['longitude'];

      final double meters = calculateDistance(
        lat,
        long,
        busStopLat,
        busStopLong,
      );

      // GET SAVE BUS STOP WITHIN 500m
      if (meters < 500) {
        tempHolder[key] = value;
      }
    });

    return tempHolder;
  }
}
