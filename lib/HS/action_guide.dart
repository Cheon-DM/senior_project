import 'package:flutter/material.dart';

import 'mainpage.dart';

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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                    return MainPage();
                  }));
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
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                            return SafeArea(
                                                child: Container(
                                                  child: Text(
                                                    "뭔가 떠라",
                                                  ),
                                                )
                                            );
                                          })
                                      );
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
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (context) {
                                              return SafeArea(
                                                  child: Container(
                                                    child: Text(
                                                      "뭔가 떠라",
                                                    ),
                                                  )
                                              );
                                            })
                                        );
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
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (context) {
                                              return SafeArea(
                                                  child: Container(
                                                    child: Text(
                                                      "뭔가 떠라",
                                                    ),
                                                  )
                                              );
                                            })
                                        );
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
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (context) {
                                              return SafeArea(
                                                  child: Container(
                                                    child: Text(
                                                      "뭔가 떠라",
                                                    ),
                                                  )
                                              );
                                            })
                                        );
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "메뉴1.1 value",
                        style: TextStyle(
                          fontFamily: 'Leferi',
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        height: 15,
                      ),
                      Text(
                        "상황별 행동지침(국민재난안전포털 웹크롤링)",
                        style: TextStyle(
                          fontFamily: 'Leferi',
                          fontSize: 12,
                        ),
                      )
                    ],
                  ),
                ),
                flex: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*
* <div class="section01">
                    <div class="tabarea">
                        <div class="tabmenu01 on">
                           <div class="detail">
                              <h3 class="title_02">홍수 예·경보 시 국민행동요령</h3>
*
* 자연재난
* 02, 13, 18, 04, 05, 06, 19, 08, 07, 12, 09, 16, 10, 20, 11
*
* */