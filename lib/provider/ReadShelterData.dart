import 'dart:math';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math.dart';

class ShelterProvider extends ChangeNotifier {
  int j=0; // 대피소 저장 리스트 인덱스
  Map<int, List<dynamic>> mp = Map<int, List<dynamic>>(); // 대피소 저장 리스트

  late String jsonAround1;
  late String jsonAround2;
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
        tmp.add(row[0]!.props.first); // 대피소

        mp[j] = tmp;
        j++;
      }
    }
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