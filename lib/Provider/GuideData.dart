import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

class GuideDataProvider extends ChangeNotifier{

  List<String> statement = [];

  int getNationalGuideStep(int number){
    return 1;
  }

  getNational(int number) async {
    // 자연재난 (safety_cate=01001~01015)
    List<String> NationalList = ['01001', '01002', '01003', '01004', '01005', '01006', '01007', '01008', '01009', '01010', '01011', '01012', '01013', '01014', '01015'];
    String url = 'http://openapi.safekorea.go.kr/openapi/service/behaviorconductKnowHow/naturaldisaster/list?safety_cate=';
    final String safety_cate = NationalList[number];
    final String serviceKey = '&serviceKey=yoSJ384pthej3NXwL5MttpP8%2FNOoNFAov7nWzBppOC7CGW%2F%2FuuVjkeqUuU2z8agn4TkZWDYXqbDYUL7DWu8pFg%3D%3D';
    url = url + safety_cate + serviceKey;
    final response = await http.get(Uri.parse(url));

    var utfBody = utf8.decode(response.bodyBytes);
    var body = XmlDocument.parse(utfBody);

    final wantData = body.findAllElements('item');

    var num = body.findAllElements('safetyCate3');
    var numList = Set();
    num.forEach((element) {
      numList.add(element.text);
    });

    statement.clear();
    for (var i in numList) {
      wantData.forEach((element) {
        if (i == element.getElement('safetyCate3')?.text){
          print(element.getElement('actRmks')?.text);
          if (element.getElement('actRmks')?.text == null) {

          }
          else {
            statement.add(element.getElement('actRmks')!.text);
          }
        }
      });
    }
  }

  getSocialGuideLine(){

  }

  getLifeGuideLine(){

  }

  getEmergencyGuideLine(){

  }
}

// 자연재난 (safety_cate=01001~01015)
// http://openapi.safekorea.go.kr/openapi/service/behaviorconductKnowHow/naturaldisaster/list?safety_cate=01001&serviceKey=yoSJ384pthej3NXwL5MttpP8%2FNOoNFAov7nWzBppOC7CGW%2F%2FuuVjkeqUuU2z8agn4TkZWDYXqbDYUL7DWu8pFg%3D%3D

// 사회재난 (safety_cate=02001~02023)
// http://openapi.safekorea.go.kr/openapi/service/behaviorconduct/socialdisaster/list?safety_cate=02001&serviceKey=yoSJ384pthej3NXwL5MttpP8%2FNOoNFAov7nWzBppOC7CGW%2F%2FuuVjkeqUuU2z8agn4TkZWDYXqbDYUL7DWu8pFg%3D%3D

// 생활안전 (safety_cate=03002~03017)
// http://openapi.safekorea.go.kr/openapi/service/behaviorconduct/lifesafety/list?safety_cate=03002&serviceKey=yoSJ384pthej3NXwL5MttpP8%2FNOoNFAov7nWzBppOC7CGW%2F%2FuuVjkeqUuU2z8agn4TkZWDYXqbDYUL7DWu8pFg%3D%3D

// 비상재난 (safety_cate=04001~04003)
// http://openapi.safekorea.go.kr/openapi/service/behaviorconduct/disaster/civildefence/total/list?safety_cate=04001&serviceKey=yoSJ384pthej3NXwL5MttpP8%2FNOoNFAov7nWzBppOC7CGW%2F%2FuuVjkeqUuU2z8agn4TkZWDYXqbDYUL7DWu8pFg%3D%3D