import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class test extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'test',
      home: testPage(),
    );
  }
}

class testPage extends StatefulWidget{
  @override
  _testPageState createState() => _testPageState();
}

class _testPageState extends State<testPage>{
  final String url = 'https://www.safekorea.go.kr/idsiSFK/sfk/cs/sua/web/DisasterSmsList.do';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("test"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('버튼을 누르면 하단 글귀가 변경됩니다.', style: TextStyle(color: Colors.indigo, fontSize: 20.0, fontWeight: FontWeight.bold),),
          ],
        ),
      ),

      floatingActionButton: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  margin: const EdgeInsets.only(left: 180.0),
                  child: Text("Get  Post", style: TextStyle(color: Colors.blueAccent, fontSize: 28.0, fontWeight: FontWeight.bold),)
              ),
            ),

            Align(
              alignment: Alignment.bottomRight,
              child:  FloatingActionButton(
                onPressed: () async {
                  DateTime now = DateTime.now();
                  DateTime before_5 = DateTime.now().subtract(Duration(days: 1));
                  DateFormat formatter = DateFormat('yyyy-MM-dd');

                  String nowString = formatter.format(now);
                  String pastString5 = formatter.format(before_5);

                  Map<String, String> headers = {
                    'Content-Type': 'application/json',
                    'Accept-Encoding': 'gzip, deflate, br'
                  };

                  var initbodyData = {
                    "searchInfo":
                    {"pageIndex":"1",
                      "pageUnit":"10",
                      "pageSize":"10",
                      "firstIndex":"1",
                      "lastIndex":"1",
                      "recordCountPerPage":"10",
                      "searchBgnDe": pastString5,
                      "searchEndDe": nowString,
                      "searchGb":"1",
                      "searchWrd":"",
                      "rcv_Area_Id":"",
                      "dstr_se_Id":"",
                      "c_ocrc_type":"",
                      "sbLawArea1":"",
                      "sbLawArea2":""
                    }};

                  var initbody = json.encode(initbodyData);
                  final initResponse = await http.post(Uri.parse(url), headers: headers, body: initbody);
                  final int statusCode = initResponse.statusCode;
                  print("--- 상태 코드 ---");
                  print(statusCode);

                  var rtnPageCnt = jsonDecode(initResponse.body)['rtnResult']['pageSize'];
                  print("---필요 page 수---");
                  print(rtnPageCnt);

                  var ref = FirebaseFirestore.instance.collection("disaster_message");

                  for (int i = 1; i <= rtnPageCnt; i++){
                    var bodyData = {
                      "searchInfo":
                      {"pageIndex": i,
                        "pageUnit":"10",
                        "pageSize":"10",
                        "firstIndex":"1",
                        "lastIndex":"1",
                        "recordCountPerPage":"10",
                        "searchBgnDe": pastString5,
                        "searchEndDe": nowString,
                        "searchGb":"1",
                        "searchWrd":"",
                        "rcv_Area_Id":"",
                        "dstr_se_Id":"",
                        "c_ocrc_type":"",
                        "sbLawArea1":"",
                        "sbLawArea2":""
                      }};

                    var body = json.encode(bodyData);
                    final response = await http.post(Uri.parse(url), headers: headers, body: body);
                    var bodyDecode = json.decode(response.body)['disasterSmsList'];
                    for (int j = 0; j < bodyDecode.length; j++ ){
                      var DATE = bodyDecode[j]["MODF_DT"];
                      final splitted = DATE.split(" ");

                      var CREATE_DT = splitted[0];
                      var MD101_SN = bodyDecode[j]["MD101_SN"];
                      var DSSTR_SE_ID = bodyDecode[j]["DSSTR_SE_ID"];
                      DSSTR_SE_ID = int.parse(DSSTR_SE_ID);
                      var RCV_AREA_ID = bodyDecode[j]["RCV_AREA_ID"];
                      RCV_AREA_ID = int.parse(RCV_AREA_ID);
                      var LOC;
                      if (RCV_AREA_ID >= 2 && RCV_AREA_ID <= 20) LOC = 1;
                      else if (RCV_AREA_ID >= 21 && RCV_AREA_ID <= 52) LOC = 2;
                      else if (RCV_AREA_ID >= 53 && RCV_AREA_ID <= 73) LOC = 3;
                      else if (RCV_AREA_ID >= 74 && RCV_AREA_ID <= 97) LOC = 4;
                      else if (RCV_AREA_ID >= 98 && RCV_AREA_ID <= 103) LOC = 5;
                      else if (RCV_AREA_ID >= 104 && RCV_AREA_ID <= 112) LOC = 6;
                      else if (RCV_AREA_ID >= 113 && RCV_AREA_ID <= 118) LOC = 7;
                      else if (RCV_AREA_ID >= 119 && RCV_AREA_ID <= 135) LOC = 8;
                      else if (RCV_AREA_ID >= 136 && RCV_AREA_ID <= 161) LOC = 9;
                      else if (RCV_AREA_ID == 6474) LOC = 10;
                      else if (RCV_AREA_ID >= 162 && RCV_AREA_ID <= 167) LOC = 11;
                      else if (RCV_AREA_ID >= 168 && RCV_AREA_ID <= 178) LOC = 12;
                      else if (RCV_AREA_ID >= 179 && RCV_AREA_ID <= 201) LOC = 13;
                      else if (RCV_AREA_ID >= 202 && RCV_AREA_ID <= 216) LOC = 14;
                      else if (RCV_AREA_ID >= 217 && RCV_AREA_ID <= 221) LOC = 15;
                      else if (RCV_AREA_ID >= 222 && RCV_AREA_ID <= 250) LOC = 16;
                      else if (RCV_AREA_ID >= 251) LOC = 17;


                      var RCV_AREA_NM = bodyDecode[j]["RCV_AREA_NM"];
                      var MSG_CN = bodyDecode[j]["MSG_CN"];

                      final item = ref.doc("${MD101_SN}");
                      var checking = await item.get();

                      if(checking.exists){ // msg exist

                      }

                      else {
                        item.set({
                          "MD101_SN" : MD101_SN,  // 재난문자번호
                          "CREATE_DT": CREATE_DT, // 날짜
                          "LOC" : LOC, // 시,도 구분
                          "RCV_AREA_ID": RCV_AREA_ID, // 지역번호
                          "RCV_AREA_NM" : RCV_AREA_NM, // 지역이름
                          "DSSTR_SE_ID": DSSTR_SE_ID, // 재난번호
                          "MSG_CN": MSG_CN, // 문자내용
                        });
                      }
                      print(MD101_SN);
                    }

                  }

                  setState(() {
                  });
                },
                child: Icon(Icons.chevron_right),
              ),
            )
          ]
      ),
    );
  }
}



Future<DisasterInfo> fetchInfo() async {
  var url = 'https://www.safekorea.go.kr/idsiSFK/sfk/cs/sua/web/DisasterSmsList.do';
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept-Encoding': 'gzip, deflate, br'
  };

  var bodyData = {
    "searchInfo":
    {"pageIndex":"1",
      "pageUnit":"10",
      "pageSize":"10",
      "firstIndex":"1",
      "lastIndex":"1",
      "recordCountPerPage":"10",
      "searchBgnDe":"2022-09-22",
      "searchEndDe":"2022-09-22",
      "searchGb":"1",
      "searchWrd":"",
      "rcv_Area_Id":"",
      "dstr_se_Id":"",
      "c_ocrc_type":"",
      "sbLawArea1":"",
      "sbLawArea2":""
    }};

  var body = json.encode(bodyData);

  final response = await http.post(Uri.parse(url), headers: headers, body: body);
  final int statusCode = response.statusCode;
  if (statusCode < 200 || statusCode > 400 || json == null){

  }
  return json.decode(utf8.decode(response.bodyBytes));
}

class DisasterInfo {
  final String disasterSmsList;
  final String rtnResult;

  DisasterInfo({
    required this.disasterSmsList,
    required this.rtnResult});

  factory DisasterInfo.fromJson(Map<String, dynamic> json){

    print('disasterSmsList : ${json['disasterSmsList']}');
    print('rtnResult : ${json['rtnResult']}');

    return DisasterInfo(
        disasterSmsList: json["disasterSmsList"],
        rtnResult: json["rtnResult"]);
  }
}