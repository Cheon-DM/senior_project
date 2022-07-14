import 'package:flutter/cupertino.dart';

class GuideLineModel {
  final String index;
  final String title1;
  final String title2;
  final String maintext;

  GuideLineModel({
    required this.index,
    required this.title1,
    required this.title2,
    required this.maintext
  });

  factory GuideLineModel.fromJson(Map<String, dynamic> json) {
    /*
    if(json == null) {
      return GuideLineModel(
          index: '-1',
          title1: 'title1',
          title2: 'title2',
          maintext: 'maintext');
    }
     */
    return GuideLineModel(
        index: json['index'] as String,
        title1: json['title1'] as String,
        title2: json['title2'] as String,
        maintext: json['maintext'] as String
    );
  }
}
