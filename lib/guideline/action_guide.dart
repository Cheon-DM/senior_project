import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../mainpage.dart';
import '../provider/GuideData.dart';

class ActionGuide extends StatefulWidget {
  @override
  _ActionGuideState createState() => _ActionGuideState();
}

class _ActionGuideState extends State<ActionGuide> {
  List<String> NationalList = ['태풍', '홍수', '호우', '강풍', '대설', '한파', '풍랑', '황사', '폭염', '가뭄', '지진', '지진해일', '해일', '산사태', '화산폭발'];

  List<String> SocialList = ['해양오염사고', '대규모 수질오염', '식용수', '공동구 재난', '가축질병', '감염병 예방', '철도,지하철사고', '금융전산', '원전사고', '화학물질사고', '화재'
  , '산불', '건축물 붕괴', '댐 붕괴', '폭발', '항공기사고', '화생방사고', '정전', '전기,가스사고', '유도선 사고', '수난사고', '테러발생시', '전력수급단계별'];

  List<String> LifeList = ['응급처치', '심폐소생술', '소화기사용법', '식중독', '산행안전', '놀이시설', '실종유괴 예방', '성폭력 예방', '학교 폭력 예방', '가정 폭력 예방', '억류 및 납치 시 대처요령', '교통사고'
  , '승강기 안전사고', '미세먼지', '소화전사용법', '가정 안전점검'];

  List<String> EmergencyList = ['비상사태', '민방공', '화생방무기'];

  int guideNumber = 0;
  List<String> title = ["title"]; // head = title1 모음
  List<List<String>> subTitle = [["subTitle"]];
  List<List<List<String>>> statement = [[["test"]]];

  Stream<int> showGuide() async*{
    yield guideNumber;
  }

  late GuideDataProvider guideDataProvider = Provider.of<GuideDataProvider>(context, listen: false);

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'action-guide',
      home: Scaffold(
        resizeToAvoidBottomInset : false,
        appBar: AppBar(
          backgroundColor: const Color(0xff6157DE),
          elevation: 0,
          title: Text(
            "행동지침",
            style: TextStyle(
              fontFamily: 'Leferi',
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),

        body: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //화면 좌측 분할부(메뉴)
              Expanded(
                child: Container(
                  color: Color(0xff6157de),
                  child: ListView(
                    children: <Widget>[
                      //행동요령 매뉴얼 내용부
                      ExpansionTile( // 자연재난
                        title: Text(
                          "자연재난행동요령",
                          style: TextStyle(
                            fontFamily: 'Leferi',
                            fontSize: 14,
                          ),
                        ),
                        backgroundColor: Colors.grey[200],
                        collapsedBackgroundColor: Color(0xff6157de),
                        collapsedTextColor: Colors.white,
                        textColor: Colors.black,
                        iconColor: Colors.black,
                        collapsedIconColor: Colors.white,

                        children: <Widget>[
                          ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: 15,
                              itemBuilder: (context, index) =>
                                  ListTile(
                                    title: Text(
                                      NationalList[index],
                                      style: TextStyle(
                                        fontFamily: 'Leferi',
                                        fontSize: 12,
                                      ),
                                    ),
                                    textColor: Colors.black,
                                    onTap: () {
                                      guideDataProvider.getNationalGuide(index);
                                      setState(() {
                                        guideNumber = index;
                                        title.clear();
                                        subTitle.clear();
                                        statement.clear();
                                        title = context.read<GuideDataProvider>().title;
                                        subTitle = context.read<GuideDataProvider>().subTitle;
                                        statement = context.read<GuideDataProvider>().statement;
                                      });
                                    }
                                  )
                          ),
                        ],
                      ),

                      ExpansionTile( // 사회재난
                        title: Text(
                          "사회재난행동요령",
                          style: TextStyle(
                            fontFamily: 'Leferi',
                            fontSize: 14,
                          ),
                        ),
                        backgroundColor: Colors.grey[200],
                        collapsedBackgroundColor: Color(0xff6157de),
                        collapsedTextColor: Colors.white,
                        textColor: Colors.black,
                        iconColor: Colors.black,
                        collapsedIconColor: Colors.white,

                        children: <Widget>[
                          ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: 23,
                              itemBuilder: (context, index) =>
                                  ListTile(
                                      title: Text(
                                        SocialList[index],
                                        style: TextStyle(
                                          fontFamily: 'Leferi',
                                          fontSize: 12,
                                        ),
                                      ),
                                      textColor: Colors.black,
                                      onTap: () {
                                        guideDataProvider.getSocialGuide(index);
                                        setState(() {
                                          guideNumber = index;
                                          title.clear();
                                          subTitle.clear();
                                          statement.clear();
                                          title = context.read<GuideDataProvider>().title;
                                          subTitle = context.read<GuideDataProvider>().subTitle;
                                          statement = context.read<GuideDataProvider>().statement;
                                        });
                                      }
                                  )
                          ),
                        ],
                      ),

                      ExpansionTile( // 생활안전
                        title: Text(
                          "생활안전행동요령",
                          style: TextStyle(
                            fontFamily: 'Leferi',
                            fontSize: 14,
                          ),
                        ),
                        backgroundColor: Colors.grey[200],
                        collapsedBackgroundColor: Color(0xff6157de),
                        collapsedTextColor: Colors.white,
                        textColor: Colors.black,
                        iconColor: Colors.black,
                        collapsedIconColor: Colors.white,

                        children: <Widget>[
                          ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: 16,
                              itemBuilder: (context, index) =>
                                  ListTile(
                                      title: Text(
                                        LifeList[index],
                                        style: TextStyle(
                                          fontFamily: 'Leferi',
                                          fontSize: 12,
                                        ),
                                      ),
                                      textColor: Colors.black,
                                      onTap: () {
                                        guideDataProvider.getLifeGuide(index);
                                        setState(() {
                                          guideNumber = index;
                                          title.clear();
                                          subTitle.clear();
                                          statement.clear();
                                          title = context.read<GuideDataProvider>().title;
                                          subTitle = context.read<GuideDataProvider>().subTitle;
                                          statement = context.read<GuideDataProvider>().statement;
                                        });
                                      }
                                  )
                          ),
                        ],
                      ),

                      ExpansionTile( // 비상대비
                        title: Text(
                          "비상대비행동요령",
                          style: TextStyle(
                            fontFamily: 'Leferi',
                            fontSize: 14,
                          ),
                        ),
                        backgroundColor: Colors.grey[200],
                        collapsedBackgroundColor: Color(0xff6157de),
                        collapsedTextColor: Colors.white,
                        textColor: Colors.black,
                        iconColor: Colors.black,
                        collapsedIconColor: Colors.white,

                        children: <Widget>[
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: 3,
                              itemBuilder: (context, index) =>
                                  ListTile(
                                      title: Text(
                                        EmergencyList[index],
                                        style: TextStyle(
                                          fontFamily: 'Leferi',
                                          fontSize: 12,
                                        ),
                                      ),
                                      textColor: Colors.black,
                                      onTap: () {
                                        guideDataProvider.getEmergencyGuide(index);
                                        setState(() {
                                          guideNumber = index;
                                          title.clear();
                                          subTitle.clear();
                                          statement.clear();
                                          title = context.read<GuideDataProvider>().title;
                                          subTitle = context.read<GuideDataProvider>().subTitle;
                                          statement = context.read<GuideDataProvider>().statement;
                                        });
                                      }
                                  )
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                flex: 2,
              ),

              //화면 우측 분할부(내용)
              StreamBuilder(
                stream: showGuide(),
                builder: (context, snapshot) {
                  return Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: context.read<GuideDataProvider>().title.length,
                        itemBuilder: (context, index) =>
                            ExpansionTile(
                              title: Text(context.read<GuideDataProvider>().title.elementAt(index).toString()),
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: context.read<GuideDataProvider>().subTitle.elementAt(index).length,
                                          itemBuilder: (ctx, idx) => ListTile(
                                            title: Text(context.read<GuideDataProvider>().subTitle.elementAt(index).elementAt(idx).toString(),
                                              style: TextStyle(fontFamily: 'Leferi', fontSize: 15),
                                            ),
                                            onTap: () {
                                              showDialog(
                                                  useRootNavigator: false,
                                                  context: ctx,
                                                  builder: (builder) {
                                                    return AlertDialog(
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(4)
                                                      ),
                                                      scrollable: true,
                                                      content: Column(
                                                        children: <Widget>[
                                                          Text(context.read<GuideDataProvider>().statement.elementAt(index).elementAt(idx).toString(),
                                                              style: TextStyle(fontFamily: 'Leferi', fontSize: 17)
                                                          )
                                                        ],
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.of(ctx).pop();
                                                            },
                                                            child: Text("확인"))
                                                      ],
                                                    );
                                                  });
                                            },
                                          )
                                      ),
                                    )
                                  ],
                                )
                              ],
                            )
                    ),
                    flex: 3,
                  );
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}