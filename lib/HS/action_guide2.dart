import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:senior_project/HS/show_guide.dart';

import 'mainpage.dart';
import 'package:senior_project/HS/guideAPI/guideHTTP.dart';

class ActionGuide2 extends StatefulWidget {
  @override
  _ActionGuideState2 createState() => _ActionGuideState2();
}

class _ActionGuideState2 extends State<ActionGuide2> {
  bool isExpand = false;
  GuideHTTP guidehttp = GuideHTTP();


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
            "행동지침1",
            style: TextStyle(
              fontFamily: 'Leferi',
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            onPressed: (){
              // Get.to(MainPage());
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
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xff6157DE),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            child: Container(
              padding: EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              child: ListView(
                children: <Widget>[
                  Container(
                    child: Container(
                      //1. 비상사태시 행동요령
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                        child: ExpansionTile(
                          title: Text(
                            "1.비상사태시 행동요령",
                            style: TextStyle(
                              fontFamily: 'Leferi',
                              fontSize: 15,
                            ),
                          ),
                          backgroundColor: Colors.grey[200],
                          //collapsedBackgroundColor: Colors.red.withOpacity(0.0),
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
                                guidehttp.callAPI();
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
                      ),
                    ),
                  ),

                  //2. 화생방 피해대비 행동요령
                  Container(
                    child: Container(
                      //1. 비상사태시 행동요령
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                        child: ExpansionTile(
                          title: Text(
                            "2.화생방 피해대비 행동요령",
                            style: TextStyle(
                              fontFamily: 'Leferi',
                              fontSize: 15,
                            ),
                          ),
                          backgroundColor: Colors.grey[200],
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
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) {
                                    return ShowGuide();
                                  }),
                                );
                              },
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
                            )
                          ],
                        ),
                      ),
                    ),
                  ),

                  //3. 인명/시설 피해시 행동요령
                  Container(
                    child: Container(
                      //1. 비상사태시 행동요령
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                        child: ExpansionTile(
                          title: Text(
                            "3.인명/시설 피해시 행동요령",
                            style: TextStyle(
                              fontFamily: 'Leferi',
                              fontSize: 15,
                            ),
                          ),
                          backgroundColor: Colors.grey[200],
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
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) {
                                    return ShowGuide();
                                  }),
                                );
                              },
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
                            )
                          ],
                        ),
                      ),
                    ),
                  ),

                  //4. 비상대비물자 준비 및 사용요령
                  Container(
                    child: Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                        child: ExpansionTile(
                          title: Text(
                            "4.비상대비물자 준비 및 사용요령",
                            style: TextStyle(
                              fontFamily: 'Leferi',
                              fontSize: 15,
                            ),
                          ),
                          backgroundColor: Colors.grey[200],
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
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) {
                                    return ShowGuide();
                                  }),
                                );
                              },
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
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
