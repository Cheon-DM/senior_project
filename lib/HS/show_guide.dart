import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:senior_project/HS/guideLineModel.dart';

import 'action_guide.dart';
import 'action_guide2.dart';


class ShowGuide extends StatefulWidget {
  late final int num;

  @override
  _ShowGuideState createState() => _ShowGuideState();
}

class _ShowGuideState extends State<ShowGuide> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    //ReadJsonData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset : false,

        appBar: AppBar(
          backgroundColor: const Color(0xff6157DE),
          elevation: 5,
          title: Text(
            "행동지침_상세",
            style: TextStyle(
              fontFamily: 'Leferi',
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                    return ActionGuide2();
                  }));
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),

        body: FutureBuilder(
          future: ReadJsonData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.hasData == false) {
              return CircularProgressIndicator();
            }

            else if(snapshot.hasError) {
              return Padding(padding: const EdgeInsets.all(8.0),
              child: Text(
                '${snapshot.error}'
              ),);
            }
            else{
              return ExpansionTile(
                title: Text(
                  "제목 어쩌구",
                ),
                children: <Widget>[
                  ListTile(
                    title : Text(
                      "소제목 어쩌구",
                    ),
                  ),
                ],
              );

            }
          },
        )
    );

  }


  /* 제대로 잘 돌아가는 원본
  Future<List<GuideLineModel>>ReadJsonData() async {
    final jsonData = await rootBundle.rootBundle.loadString('assets/guide/guide1_1.json');
    final list = json.decode(jsonData) as List<dynamic>;

    print('${"으아아아"}');
    print('${list[0]}');
    print('${"아아아악"}');
    print('${list[1]}');
    return list.map((e) => GuideLineModel.fromJson(e)).toList();
  }
   */

  // 성공!!!!!!!!! 건드리지말기
  Future<String> ReadJsonData() async {
    final jsonData = await rootBundle.rootBundle.loadString('assets/guide/guide1_1.json');
    final list = jsonDecode(jsonData) as dynamic;
    var item = list[0].toString();
    print('${"출력값 :"}');
    print('${item}');
    return item;
    //fromJson : map구조에서 새로운 user객체를 생성하는 생성자
    //toJson : user객체를 map구조로 변환하는 함수



    //print('${list.map((e) => GuideLineModel.fromJson(e)).toList()}');

  }
}
