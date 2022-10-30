import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GuideList {
  final List<Guide>? guide;

  GuideList({
    this.guide,
  });

  factory GuideList.fromJson(List<dynamic> json){
    List<Guide> guides = <Guide>[];
    guides = json.map((e) => Guide.fromJson(e)).toList();

    return GuideList(
      guide: guides
    );
  }
}

class Guide {
  final String? index;
  final String? title1;
  final String? title2;
  final List<String>? maintext;

  Guide({
    this.index,
    this.title1,
    this.title2,
    this.maintext});

  factory Guide.fromJson(Map<String, dynamic> json){
    var maintextFromJson = json['maintext'];
    List<String> maintextList = maintextFromJson.cast<String>();
    return Guide(
      index: json['index'] as String,
      title1: json['title1'] as String,
      title2: json['title2'] as String,
      maintext: maintextList,
    );
  }
}

class GuideDataProvider extends ChangeNotifier{
  List<String> title = []; // title1 모음
  List<List<String>> subTitle = []; // 소제목
  List<List<List<String>>> statement = []; // 행동요령

  Set<String> hSet = Set();

  getNationalGuide(int index) async{
    List<String> NationalList = ['100', '101', '102', '103', '104', '105', '106', '107', '108', '109', '110', '111', '112', '113', '114'];
    String nationalString = NationalList[index];
    String jsonString = await rootBundle.loadString('assets/guide/guide1.json');
    final jsonResponse = json.decode(jsonString);
    GuideList guideList = GuideList.fromJson(jsonResponse);
    // reset
    title.clear();
    subTitle.clear();
    statement.clear();
    hSet.clear();

    // 제목 분류
    for (var value in guideList.guide!) {
      if (value.index == nationalString) {
        hSet.add(value.title1!);
      }
    }
    title = hSet.toList();

    // 소제목 + 가이드라인
    for (var i in title){
      List<List<String>> statTmp = [];
      List<String> subTmp= [];
      for (var j in guideList.guide!){
        if(i == j.title1){
          subTmp.add(j.title2!);
          statTmp.add(j.maintext!);
        }
      }
      subTitle.add(subTmp);
      statement.add(statTmp);
    }
  }

  getSocialGuide(int index) async {
    List<String> SocialList = ['200', '201', '202', '203', '204', '205', '206', '207', '208', '209', '210',
      '211', '212', '213', '214', '215', '216', '217', '218', '219', '220', '221', '222'];
    String SocialString = SocialList[index];
    String jsonString = await rootBundle.loadString('assets/guide/guide2.json');
    final jsonResponse = json.decode(jsonString);
    GuideList guideList = GuideList.fromJson(jsonResponse);

    // reset
    title.clear();
    subTitle.clear();
    statement.clear();
    hSet.clear();

    // 제목 분류
    for (var value in guideList.guide!) {
      if (value.index == SocialString) {
        hSet.add(value.title1!);
      }
    }
    title = hSet.toList();

    // 소제목 + 가이드라인
    for (var i in title){
      List<List<String>> statTmp = [];
      List<String> subTmp= [];
      for (var j in guideList.guide!){
        if(i == j.title1){
          subTmp.add(j.title2!);
          statTmp.add(j.maintext!);
        }
      }
      subTitle.add(subTmp);
      statement.add(statTmp);
    }
  }

  getLifeGuide(int index) async {
    List<String> LifeList = ['300', '301', '302', '303', '304', '305', '306', '307', '308', '309', '310', '311', '312', '313', '314', '315'];
    String LifeString = LifeList[index];
    String jsonString = await rootBundle.loadString('assets/guide/guide3.json');
    final jsonResponse = json.decode(jsonString);
    GuideList guideList = GuideList.fromJson(jsonResponse);

    // reset
    title.clear();
    subTitle.clear();
    statement.clear();
    hSet.clear();

    // 제목 분류
    for (var value in guideList.guide!) {
      if (value.index == LifeString) {
        hSet.add(value.title1!);
      }
    }
    title = hSet.toList();

    // 소제목 + 가이드라인
    for (var i in title){
      List<List<String>> statTmp = [];
      List<String> subTmp= [];
      for (var j in guideList.guide!){
        if(i == j.title1){
          subTmp.add(j.title2!);
          statTmp.add(j.maintext!);
        }
      }
      subTitle.add(subTmp);
      statement.add(statTmp);
    }
  }

  getEmergencyGuide(int index) async {
    List<String> EmergencyList = ['400', '401', '402'];
    String EmergencyString = EmergencyList[index];
    String jsonString = await rootBundle.loadString('assets/guide/guide4.json');
    final jsonResponse = json.decode(jsonString);
    GuideList guideList = GuideList.fromJson(jsonResponse);

    // reset
    title.clear();
    subTitle.clear();
    statement.clear();
    hSet.clear();

    // 제목 분류
    for (var value in guideList.guide!) {
      if (value.index == EmergencyString) {
        hSet.add(value.title1!);
      }
    }
    title = hSet.toList();

    // 소제목 + 가이드라인
    for (var i in title){
      List<List<String>> statTmp = [];
      List<String> subTmp= [];
      for (var j in guideList.guide!){
        if(i == j.title1){
          subTmp.add(j.title2!);
          statTmp.add(j.maintext!);
        }
      }
      subTitle.add(subTmp);
      statement.add(statTmp);
    }
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