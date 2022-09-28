import 'dart:convert';
import 'dart:math';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:senior_project/Provider/LocateData.dart';
import 'package:vector_math/vector_math.dart';

// class _ShelterProvider extends StatefulWidget{
//   @override
//   State<StatefulWidget> createState() => ShelterProvider();
//
// }

class ShelterProvider extends ChangeNotifier {
  int j=0; // 대피소 저장 리스트 인덱스
  Map<int, List<dynamic>> mp = Map<int, List<dynamic>>(); // 대피소 저장 리스트

  // late LocateProvider _locateProvider = Provider.of<LocateProvider>(context, listen: false);
  // List<Map<String, dynamic>> around1 = []; // 1km 근방
  // List<Map<String, dynamic>> around2 = []; // 2km 근방
  late String jsonAround1;
  late String jsonAround2;
  String get _jsonAround1 => jsonAround1;
  String get _jsonAround2 => jsonAround2;
  List<Map<String, dynamic>> around1KM = [];
  List<Map<String, dynamic>> around2KM = [];

  num min_dis = 100000;
  var min_index = 0;

  Future<void> readExcelFile() async {
    ByteData data = await rootBundle.load("assets/Nationwide_shelter.xlsx");
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);

    for (var table in excel.tables.keys) {
      for (var row in excel.tables[table]!.rows) {
        List<dynamic> tmp = [];
        tmp.add(row[8]!.props.first); // 경도
        tmp.add(row[9]!.props.first); // 위도
//        tmp.add(row[5]!.props.first); // 대피소
        mp[j] = tmp;
        j++;
      }
    }

    // _locateProvider.locateMe(); // 내 위치
    //
    //   int a = 0; // 1km list
    //   int b = 0; // 2km list
    //
    //   for(int i = 1; i< mp.length; i++){
    //     // lat : 위도, lng : 경도
    //     double lat2 = mp[i]![2]; // 위도
    //     double lng2 = mp[i]![1]; // 경도
    //     String spot = mp[i]![0]; // 장소이름
    //
    //     num distance = calculate(context.read<LocateProvider>().my_lat, lat2, context.read<LocateProvider>().my_lng, lng2); // 거리 계산
    //
    //     if (min_dis > distance){
    //       min_dis = distance;
    //       min_index = i;
    //       print(min_index);
    //     }
    //
    //     if (distance <= 1){
    //       Map<String, dynamic> tmp = {
    //         'spot': spot as String,
    //         'lat': lat2,
    //         'lng': lng2,
    //       };
    //       around1KM.add(tmp);
    //       a++;
    //     }
    //
    //     if(distance > 1 && distance <= 2){
    //       Map<String, dynamic> tmp = {
    //         'spot': spot,
    //         'lat': lat2,
    //         'lng': lng2,
    //       };
    //       around2KM.add(tmp);
    //       b++;
    //     }
    //   }
    //   //refresh the UI -> 가장 가까운 대피소 찍기
    //   around1 = around1KM;
    //   around2 = around2KM;
    //   jsonAround1 = jsonEncode(around1KM);
    //   jsonAround2 = jsonEncode(around2KM);
    //   notifyListeners();
  }

  readShelterdata(){
    readExcelFile();
  }
}

num calculate(double lat1, double lat2, double lng1, double lng2){
  double dis;
  final R = 6371;

  final deltaLat = radians((lat1-lat2).abs());
  final deltaLng = radians((lng1-lng2).abs());

  final sinDeltaLat = sin(deltaLat/2);
  final sinDeltaLng = sin(deltaLng/2);
  final squareRoot = sqrt(sinDeltaLat * sinDeltaLat + cos(radians(lat1)) * cos(radians(lat2)) * sinDeltaLng * sinDeltaLng);

  dis = 2 * R * asin(squareRoot);
  return dis;
}