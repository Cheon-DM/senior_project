/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:senior_project/HS/guidePages/guide101.dart';

import 'mainpage.dart';

class ActionGuide extends StatefulWidget {
  @override
  _ActionGuideState createState() => _ActionGuideState();
}

class _ActionGuideState extends State<ActionGuide> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'action-guide',

      home: Scaffold(
        resizeToAvoidBottomInset : false,

        appBar: AppBar(
          backgroundColor: const Color(0xff6157DE),
          elevation: 5,
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
                child:
                Container(
                  color: Color(0xff6157de),
                  child: ListView(
                    children: <Widget>[

                      //행동요령 매뉴얼 내용부
                      ExpansionTile(
                        title: Text(
                          "1.비상사태시 행동요령",
                          style: TextStyle(
                            fontFamily: 'Leferi',
                            fontSize: 15,
                          ),
                        ),
                        backgroundColor: Colors.grey[200],
                        collapsedBackgroundColor: Color(0xff6157de),
                        collapsedTextColor: Colors.white,
                        textColor: Colors.black,
                        iconColor: Colors.black,
                        collapsedIconColor: Colors.white,

                        children: <Widget>[
                          ListTile(
                            title: Text(
                              "1.1.비상시 행동요령",
                              style: TextStyle(
                                fontFamily: 'Leferi',
                                fontSize: 13,
                              ),
                            ),
                            textColor: Colors.black,
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                    return Guide101();
                                  }));

                            },
                          ),

                          ListTile(
                            title: Text(
                              "1.2.민방공 경보 발령시 행동요령",
                              style: TextStyle(
                                fontFamily: 'Leferi',
                                fontSize: 13,
                              ),
                            ),
                            textColor: Colors.black,
                            onTap: () {},
                          ),

                          ListTile(
                            title: Text(
                              "1.3.일상생활 비상대비 3가지",
                              style: TextStyle(
                                fontFamily: 'Leferi',
                                fontSize: 13,
                              ),
                            ),
                            textColor: Colors.black,
                            onTap: () {},
                          )


                        ],
                      ),


                      ExpansionTile(
                        title: Text(
                          "2.화생방 피해대비 행동요령",
                          style: TextStyle(
                            fontFamily: 'Leferi',
                            fontSize: 15,
                          ),
                        ),
                        backgroundColor: Colors.grey[200],
                        collapsedBackgroundColor: Color(0xff6157de),
                        collapsedTextColor: Colors.white,
                        textColor: Colors.black,
                        iconColor: Colors.black,
                        collapsedIconColor: Colors.white,

                        children: <Widget>[
                          ListTile(
                            title: Text(
                              "2.1.핵/방사능 피폭대비 행동요령",
                              style: TextStyle(
                                fontFamily: 'Leferi',
                                fontSize: 13,
                              ),
                            ),
                            textColor: Colors.black,
                            onTap: () {},
                          ),

                          ListTile(
                            title: Text(
                              "2.2.핵/방사능 피폭대비 생존상식",
                              style: TextStyle(
                                fontFamily: 'Leferi',
                                fontSize: 13,
                              ),
                            ),
                            textColor: Colors.black,
                            onTap: () {},
                          ),

                          ListTile(
                            title: Text(
                              "2.3.생물학무기 피해대비 행동요령",
                              style: TextStyle(
                                fontFamily: 'Leferi',
                                fontSize: 13,
                              ),
                            ),
                            textColor: Colors.black,
                            onTap: () {},
                          ),

                          ListTile(
                            title: Text(
                              "2.4.화학무기 피해대비 행동요령",
                              style: TextStyle(
                                fontFamily: 'Leferi',
                                fontSize: 13,
                              ),
                            ),
                            textColor: Colors.black,
                            onTap: () {},
                          ),

                        ],
                      ),


                      ExpansionTile(
                        title: Text(
                          "3.인명/시설 피해시 행동요령",
                          style: TextStyle(
                            fontFamily: 'Leferi',
                            fontSize: 15,
                          ),
                        ),
                        backgroundColor: Colors.grey[200],
                        collapsedBackgroundColor: Color(0xff6157de),
                        collapsedTextColor: Colors.white,
                        textColor: Colors.black,
                        iconColor: Colors.black,
                        collapsedIconColor: Colors.white,

                        children: <Widget>[
                          ListTile(
                            title: Text(
                              "3.1.대형건물 붕괴/화재 행동요령",
                              style: TextStyle(
                                fontFamily: 'Leferi',
                                fontSize: 13,
                              ),
                            ),
                            textColor: Colors.black,
                            onTap: () {},
                          ),

                          ListTile(
                            title: Text(
                              "3.2.전기/물/가스 공급 중단시 행동요령",
                              style: TextStyle(
                                fontFamily: 'Leferi',
                                fontSize: 13,
                              ),
                            ),
                            textColor: Colors.black,
                            onTap: () {},
                          ),

                          ListTile(
                            title: Text(
                              "3.3.지하철 피해시 행동요령",
                              style: TextStyle(
                                fontFamily: 'Leferi',
                                fontSize: 13,
                              ),
                            ),
                            textColor: Colors.black,
                            onTap: () {},
                          ),

                          ListTile(
                            title: Text(
                              "3.4.인명/시설 피해복구 행동요령",
                              style: TextStyle(
                                fontFamily: 'Leferi',
                                fontSize: 13,
                              ),
                            ),
                            textColor: Colors.black,
                            onTap: () {},
                          ),
                        ],
                      ),


                      ExpansionTile(
                        title: Text(
                          "4.비상대비물자 준비 및 사용요령",
                          style: TextStyle(
                            fontFamily: 'Leferi',
                            fontSize: 15,
                          ),
                        ),
                        backgroundColor: Colors.grey[200],
                        collapsedBackgroundColor: Color(0xff6157de),
                        collapsedTextColor: Colors.white,
                        textColor: Colors.black,
                        iconColor: Colors.black,
                        collapsedIconColor: Colors.white,

                        children: <Widget>[
                          ListTile(
                            title: Text(
                              "4.1.비상대비물자 준비요령",
                              style: TextStyle(
                                fontFamily: 'Leferi',
                                fontSize: 13,
                              ),
                            ),
                            textColor: Colors.black,
                            onTap: () {},
                          ),

                          ListTile(
                            title: Text(
                              "4.2.화생방 대비물자 사용요령",
                              style: TextStyle(
                                fontFamily: 'Leferi',
                                fontSize: 13,
                              ),
                            ),
                            textColor: Colors.black,
                            onTap: () {},
                          ),

                          ListTile(
                            title: Text(
                              "4.3.부상자 응급조치 요령",
                              style: TextStyle(
                                fontFamily: 'Leferi',
                                fontSize: 13,
                              ),
                            ),
                            textColor: Colors.black,
                            onTap: () {},
                          )
                        ],
                      )



                    ],
                  ),
                ),
                flex: 1,
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
                          fontSize: 13,
                        ),
                      )
                    ],
                  ),
                ),
                flex: 2,
              ),

              /*
                                    ListView(
                    children: <Widget>[
                      ExpansionTile(
                        title: Text('정보1'),
                        children: <Widget>[
                          ListTile(
                            title: Text('정보1.1'),
                            onTap: () {},
                          ),
                          ListTile(
                            title: Text('정보1.2'),
                            onTap: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                  ListView(
                    children: <Widget>[

                    ],
                  )

                   */
            ],
          ),
        ),
      ),
    );
  }
}

 */