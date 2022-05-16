import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

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

    // print(result.length);
    // print(result[3]);
  }

  else {
    // 만약 요청이 실패하면, 에러를 던집니다.
    throw Exception('Failed to load post');
  }
}

Future<void> create (int BBS_ORDR, String CONT, String FRST_REGIST_DT) async {
  final item = FirebaseFirestore.instance.collection("disaster_message").doc("${BBS_ORDR}");
  var checking = await item.get();
  if(checking.exists){ // msg exist

  }
  else { // new msg
    item.set({
      "BBS_ORDR": BBS_ORDR,
      "CONT": CONT,
      "FRST_REGIST_DT": FRST_REGIST_DT
    });
  }
}
