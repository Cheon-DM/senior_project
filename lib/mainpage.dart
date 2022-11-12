import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'disasterMsg/show_disaster_msg.dart';
import 'shelter/find_shelter_map.dart';
import 'friendsManage/find_friends_map.dart';
import 'info/checkState.dart';
import 'guideline/action_guide.dart';

class MainPage extends StatefulWidget {
  static String routeName = "/";

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                backgroundColor: const Color(0xff6157DE),
                elevation: 0,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/logo_white.png',
                      fit: BoxFit.contain,
                      height: 20,
                    ),
                  ],
                ),
                actions: <Widget>[
                  IconButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return CheckState();
                      }));
                    },
                    icon: Icon(
                      Icons.perm_contact_calendar_outlined,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.white,
              body: SafeArea(
                child: Column(
                  //버튼 4개 전체적으로 정렬
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Stack(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height - 80,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white,
                                Color.fromRGBO(220, 229, 255, 0.1),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                        ),
                        Stack(
                          children: [
                            // 그림자처럼 깔린...그 부분
                            Positioned(
                              left: -7.5,
                              bottom: -13,
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                width: MediaQuery.of(context).size.width + 15,
                                margin: const EdgeInsets.only(
                                    left: 0, right: 0, bottom: 30),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    bottomRight: Radius.circular(200),
                                    bottomLeft: Radius.circular(200),
                                  ),
                                  gradient: LinearGradient(
                                      colors: [
                                        Color.fromRGBO(150, 169, 255, 0.55),
                                        Color.fromRGBO(150, 169, 255, 0.2),
                                        Color.fromRGBO(150, 169, 255, 0.55),
                                      ],
                                      begin: Alignment.bottomLeft,
                                      end: Alignment.bottomRight),
                                ),
                              ),
                            ),

                            Container(
                              child: Column(
                                //텍스트 위치 정렬
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 150,
                                  ),
                                  CupertinoButton(
                                    child: Text(
                                      "내 주변 대피소",
                                      style: TextStyle(
                                          fontFamily: 'Leferi',
                                          color: Colors.white,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                          shadows: [
                                            Shadow(
                                              color: Color.fromRGBO(
                                                  170, 179, 255, 1.0),
                                              offset: Offset(0, 0),
                                              blurRadius: 20,
                                            )
                                          ]),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AroundShelter()));
                                    },
                                  ),
                                  Text(
                                    "나와 가장 가까운 대피소",
                                    style: TextStyle(
                                        fontFamily: 'Leferi',
                                        color: Colors.white.withOpacity(0.75),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        shadows: [
                                          Shadow(
                                            color:
                                                Colors.white.withOpacity(0.7),
                                            offset: Offset(0, 0),
                                            blurRadius: 5,
                                          )
                                        ]),
                                  ),
                                  SizedBox(
                                    height: 0,
                                  ),
                                ],
                              ),

                              //보라색(내 주변 대피소)
                              height: MediaQuery.of(context).size.height * 0.38,
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.only(
                                  left: 0, right: 0, bottom: 30),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(200),
                                  bottomLeft: Radius.circular(200),
                                ),
                                gradient: LinearGradient(
                                    colors: [
                                      Color(0xff6157DE),
                                      Color.fromRGBO(100, 109, 255, 1.0)
                                          .withOpacity(0.8),
                                      /*
                                  Color.fromRGBO(170, 79, 255, 1.0)
                                  */
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter),
                              ),
                            ),
                          ],
                        ),

                        //행동지침
                        Positioned(
                          top: MediaQuery.of(context).size.height * 0.45,
                          child: Column(
                            children: [
                              Container(
                                child: Row(
                                  //박스 내부 정렬
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CupertinoButton(
                                      onPressed: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return ActionGuide();
                                        }));
                                      },
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          SizedBox(
                                            width: 25,
                                          ),
                                          Icon(
                                            Icons.menu_book_rounded,
                                            color: Colors.black,
                                            size: 30,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "행동지침",
                                            style: TextStyle(
                                              fontFamily: 'Leferi',
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 120,
                                          ),
                                          Icon(
                                            Icons.chevron_right,
                                            color: Colors.black,
                                            size: 30,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                //카드 디자인
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.only(
                                  left: 100,
                                  right: 0,
                                  top: 25,
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(50),
                                      bottomLeft: Radius.circular(50),
                                    ),
                                    color: Colors.white.withOpacity(1)),
                              ),

                              //위치공유
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CupertinoButton(
                                      onPressed: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return FindFriendLocation();
                                        }));
                                      },
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          SizedBox(
                                            width: 25,
                                          ),
                                          Icon(Icons.add_location_alt_outlined,
                                              color: Colors.black, size: 30),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "위치공유",
                                            style: TextStyle(
                                              fontFamily: 'Leferi',
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 120,
                                          ),
                                          Icon(
                                            Icons.chevron_right,
                                            color: Colors.black,
                                            size: 30,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.only(
                                  left: 100,
                                  right: 0,
                                  top: 15,
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(50),
                                      bottomLeft: Radius.circular(50),
                                    ),
                                    color: Colors.white.withOpacity(1)),
                              ),

                              //재난문자
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CupertinoButton(
                                      onPressed: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return ShowDisasterMsg();
                                        }));
                                      },
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          SizedBox(
                                            width: 25,
                                          ),
                                          Icon(
                                            Icons.sms_failed_outlined,
                                            color: Colors.black,
                                            size: 30,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "재난문자",
                                            style: TextStyle(
                                              fontFamily: 'Leferi',
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 120,
                                          ),
                                          Icon(
                                            Icons.chevron_right,
                                            color: Colors.black,
                                            size: 30,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.only(
                                  left: 100,
                                  right: 0,
                                  top: 15,
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(50),
                                      bottomLeft: Radius.circular(50),
                                    ),
                                    color: Colors.white.withOpacity(0.8)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ))),
    );
  }
}
