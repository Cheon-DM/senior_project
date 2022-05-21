import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


void update() async {
  DateTime now = DateTime.now();
  DateTime before = DateTime.now().subtract(Duration(days: 5));

  DateFormat formatter = DateFormat('yyyy-MM-dd');

  String todayString = formatter.format(now);
  String pastString = formatter.format(before);

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  var ref = firebaseFirestore.collection("disaster_message");
  List<int> deletelist = [];

  ref.get().then((value) {
    for (var doc in value.docs) {
      if (doc['FRST_REGIST_DT'] == pastString){
        deletelist.add(doc['BBS_ORDR']);

      }
    }
    print(deletelist);
    for (int i = 0; i < deletelist.length ; i++){
      ref.doc('${deletelist[i]}').delete();
    }
  });
}

void crawling() async {
  var url = Uri.parse("http://m.safekorea.go.kr/idsiSFK/neo/ext/json/disasterDataList/disasterDataList.json");

  final response = await http.get(url);

  if (response.statusCode == 200) {
    // 만약 서버로의 요청이 성공하면, JSON을 파싱합니다.
    var responseBody = utf8.decode(response.bodyBytes);
    // print('Response Body: ${response.body}');
    final List result = jsonDecode(responseBody);
    var item = result[0];
    for (int i = 0; i < result.length; i++){
      item = result[i];

      create(item['BBS_ORDR'], item['CONT'], item['FRST_REGIST_DT']);
    }
  }

  else {
    // 만약 요청이 실패하면, 에러를 던집니다.
    throw Exception('Failed to load post');
  }
}

Future<void> create (int BBS_ORDR, String CONT, String FRST_REGIST_DT) async {
  final item = FirebaseFirestore.instance.collection("disaster_message").doc("${BBS_ORDR}");
  var checking = await item.get();
  String LOCATION = FRST_REGIST_DT.substring(0,3);

  if(checking.exists){ // msg exist

  }
  else { // new msg
    item.set({
      "BBS_ORDR": BBS_ORDR,
      "CONT": CONT,
      "FRST_REGIST_DT": FRST_REGIST_DT,
      "location": LOCATION,
    });
  }
}

/*
    String sentense = "[오산시청] 5월 20일 확진자 97명";
  print(sentense);
  final re = RegExp(r'^\[[ㄱ-ㅎ가-힣]+\]');
  String location = sentense.splitMapJoin(re, onMatch: (m) => '${m[0]}', onNonMatch: (n) => '');
  print(location);
  */
