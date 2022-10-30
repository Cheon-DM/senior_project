import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Disaster {
  final int? No;
  final int? DisID;
  final String? Msg;
  final int? BigArea;
  final int? SmallArea;
  final String? CreateDate;

  Disaster({
    this.No,
    this.DisID,
    this.Msg,
    this.BigArea,
    this.SmallArea,
    this.CreateDate
  });

  Map<String, dynamic> toMap() => {
    'No': this.No,
    'DisId': this.DisID,
    'Msg': this.Msg,
    'BigArea': this.BigArea,
    'SmallArea': this.SmallArea,
    'CreateDate': this.CreateDate
  };
}

class DisasterModel {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    return await initDB();
  }

  initDB() async {
    String path = join(await getDatabasesPath(), 'disaster_msg.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  FutureOr<void> _onCreate(Database db, int version){
    String sql = '''
    CREATE TABLE disasterTable(
      No INTEGER PRIMARY KEY,
      DisID INTEGER,
      Msg TEXT,
      BigArea INTEGER,
      SmallArea INTEGER,
      CreateDate TEXT)
    ''';

    db.execute(sql);
  }
  
  Future<void> Insert(Disaster item) async {
    var db = await database;
    
    await db.insert('disasterTable', item.toMap());
  }

  Future<int> Read(int No) async {
    final db = await database;

    final List<Map<String, dynamic>> map = await db.query('disasterTable', where: 'No = ?', whereArgs: [No]);

    return map.isNotEmpty ? map.first['No'] as int : 0;
  }

  Future<List<Disaster>> SelectArea(int BigArea) async {
    var db = await database;

    final List<Map<String, dynamic>> map = await db.query('disasterTable', where: 'BigArea = ?', whereArgs: [BigArea], orderBy: 'No DESC');

    return List.generate(map.length, (index) {
      return Disaster(
        No: map[index]['No'] as int,
        DisID: map[index]['DisID'] as int,
        Msg: map[index]['Msg'] as String,
        BigArea: map[index]['BigArea'] as int,
        SmallArea: map[index]['SmallArea'] as int,
        CreateDate: map[index]['CreateDate'] as String,
      );
    });
  }

  Future<List<Disaster>> SelectAll() async {
    var db = await database;
    final List<Map<String, dynamic>> map = await db.query('disasterTable', orderBy: 'No DESC');
    return List.generate(map.length, (index) {
      return Disaster(
        No: map[index]['No'] as int,
        DisID: map[index]['DisID'] as int,
        Msg: map[index]['Msg'] as String,
        BigArea: map[index]['BigArea'] as int,
        SmallArea: map[index]['SmallArea'] as int,
        CreateDate: map[index]['CreateDate'] as String,
      );
    });
  }

  Future<void> Delete(String CreateDate) async{
    var db = await database;

    await db.delete(
        'disasterTable',
      where: 'CreateDate < ?',
      whereArgs: [CreateDate]
    );
  }

  Future<void> Reset() async{
    var db = await database;

    db.delete("disasterTable");
  }
}

class DisasterMsgProvider extends ChangeNotifier {
  final _model = DisasterModel();
  final String url = 'https://www.safekorea.go.kr/idsiSFK/sfk/cs/sua/web/DisasterSmsList.do';

  void delete() async{
    DateTime before = DateTime.now().subtract(Duration(days: 1));
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String pastString = formatter.format(before);
    await _model.Delete(pastString);
  }

  Future<List<Disaster>> selectArea(int BigArea) async {
    var list = await _model.SelectArea(BigArea);
    return list;
  }

  Future<List<Disaster>> select() async {
    var list = await _model.SelectAll();
    return list;
  }

  void reset() async {
    await _model.Reset();
  }

  void insert() async {
    DateTime now = DateTime.now();
    DateTime before = DateTime.now().subtract(Duration(days: 2));
    DateFormat formatter = DateFormat('yyyy-MM-dd');

    String nowString = formatter.format(now);
    String pastString5 = formatter.format(before);

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept-Encoding': 'gzip, deflate, br'
    };

    var initbodyData = {
      "searchInfo":
      {"pageIndex": "1",
        "pageUnit": "10",
        "pageSize": "10",
        "firstIndex": "1",
        "lastIndex": "1",
        "recordCountPerPage": "10",
        "searchBgnDe": pastString5,
        "searchEndDe": nowString,
        "searchGb": "1",
        "searchWrd": "",
        "rcv_Area_Id": "",
        "dstr_se_Id": "",
        "c_ocrc_type": "",
        "sbLawArea1": "",
        "sbLawArea2": ""
      }};

    var initbody = json.encode(initbodyData);
    final initResponse = await http.post(Uri.parse(url), headers: headers, body: initbody);
    final int statusCode = initResponse.statusCode;
    var rtnPageCnt = jsonDecode(initResponse.body)['rtnResult']['pageSize'];

    for (int i = 1; i <= rtnPageCnt; i++) {
      var bodyData = {
        "searchInfo":
        {"pageIndex": i,
          "pageUnit": "10",
          "pageSize": "10",
          "firstIndex": "1",
          "lastIndex": "1",
          "recordCountPerPage": "10",
          "searchBgnDe": pastString5,
          "searchEndDe": nowString,
          "searchGb": "1",
          "searchWrd": "",
          "rcv_Area_Id": "",
          "dstr_se_Id": "",
          "c_ocrc_type": "",
          "sbLawArea1": "",
          "sbLawArea2": ""
        }};

      var body = json.encode(bodyData);
      final response = await http.post(
          Uri.parse(url), headers: headers, body: body);
      var bodyDecode = json.decode(response.body)['disasterSmsList'];
      for (int j = 0; j < bodyDecode.length; j++) {
        var DATE = bodyDecode[j]["MODF_DT"];
        final splitted = DATE.split(" ");
        var CREATE_DT = splitted[0];

        var MD101_SN = bodyDecode[j]["MD101_SN"];
        var DSSTR_SE_ID = bodyDecode[j]["DSSTR_SE_ID"];
        DSSTR_SE_ID = int.parse(DSSTR_SE_ID);
        var multiarea = bodyDecode[j]["RCV_AREA_ID"];
        final RCV_AREA = multiarea.split(",");
        var RCV_AREA_ID = int.parse(RCV_AREA[0]);
        var LOC;
        if (RCV_AREA_ID >= 2 && RCV_AREA_ID <= 20)
          LOC = 1;
        else if (RCV_AREA_ID >= 21 && RCV_AREA_ID <= 52)
          LOC = 2;
        else if (RCV_AREA_ID >= 53 && RCV_AREA_ID <= 73)
          LOC = 3;
        else if (RCV_AREA_ID >= 74 && RCV_AREA_ID <= 97)
          LOC = 4;
        else if (RCV_AREA_ID >= 98 && RCV_AREA_ID <= 103)
          LOC = 5;
        else if (RCV_AREA_ID >= 104 && RCV_AREA_ID <= 112)
          LOC = 6;
        else if (RCV_AREA_ID >= 113 && RCV_AREA_ID <= 118)
          LOC = 7;
        else if (RCV_AREA_ID >= 119 && RCV_AREA_ID <= 135)
          LOC = 8;
        else if (RCV_AREA_ID >= 136 && RCV_AREA_ID <= 161)
          LOC = 9;
        else if (RCV_AREA_ID == 6474)
          LOC = 10;
        else if (RCV_AREA_ID >= 162 && RCV_AREA_ID <= 167)
          LOC = 11;
        else if (RCV_AREA_ID >= 168 && RCV_AREA_ID <= 178)
          LOC = 12;
        else if (RCV_AREA_ID >= 179 && RCV_AREA_ID <= 201)
          LOC = 13;
        else if (RCV_AREA_ID >= 202 && RCV_AREA_ID <= 216)
          LOC = 14;
        else if (RCV_AREA_ID >= 217 && RCV_AREA_ID <= 221)
          LOC = 15;
        else if (RCV_AREA_ID >= 222 && RCV_AREA_ID <= 250)
          LOC = 16;
        else if (RCV_AREA_ID >= 251) LOC = 17;

        var RCV_AREA_NM = bodyDecode[j]["RCV_AREA_NM"];
        var MSG_CN = bodyDecode[j]["MSG_CN"];

        int preReader = await _model.Read(MD101_SN);
        if (preReader == 0){
          await _model.Insert(Disaster(
              No: MD101_SN,
              DisID: DSSTR_SE_ID,
              Msg: MSG_CN,
              BigArea: LOC,
              SmallArea: RCV_AREA_ID,
              CreateDate: CREATE_DT
          ));
        }
        else {
        }
      }
    }
  }
}