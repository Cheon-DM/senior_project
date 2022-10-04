import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../DM/disaster.dart';
import '../DM/findShelter.dart';
import '../DM/map.dart';
import '../HW/checkState.dart';
import 'action_guide2.dart';
import 'action_guide3.dart';


import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';


class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
          child: Scaffold(
              resizeToAvoidBottomInset : false,
              appBar: AppBar(
                backgroundColor: const Color(0xff6157DE),
                elevation: 0,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/logo_white.png',
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
                            return checkState();
                          }));
                    },
                    icon: Icon(
                      Icons.perm_contact_calendar_outlined,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.grey[200],
              body: SafeArea(
                child: Column(
                  //버튼 4개 전체적으로 정렬
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 0,
                    ),
                    Container(
                      child: Column(
                        //텍스트 위치 정렬
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CupertinoButton(
                            child: Text(
                              "내 주변 대피소",
                              style: TextStyle(
                                  fontFamily: 'Leferi',
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.5),
                                      offset: Offset(0, 2),
                                      blurRadius: 5,
                                    )
                                  ]),
                            ),
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => aroundShelter()
                                  ));
                            },
                          ),
                          SizedBox(
                            height: 0,
                          ),
                          Text(
                            "나와 가장 가까운 대피소",
                            style: TextStyle(
                              fontFamily: 'Leferi',
                              color: Colors.grey[300],
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                        ],
                      ),

                      //보라색(내 주변 대피소)
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: MediaQuery.of(context).size.width,
                      margin:
                          const EdgeInsets.only(left: 0, right: 0, bottom: 30),
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(0),
                            bottomLeft: Radius.circular(100),
                          ),
                          color: const Color(0xff6157DE),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 10,
                              spreadRadius: 5,
                              offset: Offset(0, 5),
                            ),
                          ]),
                    ),

                    //행동지침
                    Container(
                      child: Row(
                        //박스 내부 정렬
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CupertinoButton(
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                    return ActionGuide3();
                                  }));
                            },
                            child: Row(
                              children: <Widget>[
                                Container(
                                  child: Container(
                                    child: Icon(
                                      Icons.menu_book_rounded,
                                      color: Colors.black,
                                      size: MediaQuery.of(context).size.height *
                                          0.12 *
                                          0.4,
                                    ),
                                    margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                  ),
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
                              ],
                            ),
                          ),
                        ],
                      ),
                      //카드 디자인
                      height: MediaQuery.of(context).size.height * 0.12,
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(
                        left: 100,
                        right: 0,
                        top: 25,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            bottomLeft: Radius.circular(30),
                          ),
                          color: Colors.grey[200],
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 15,
                              spreadRadius: 1,
                              offset: Offset(4, 4),
                            ),
                            BoxShadow(
                              color: Colors.white,
                              blurRadius: 15,
                              spreadRadius: 1,
                              offset: Offset(-4, -4),
                            )
                          ]),
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
                                  MaterialPageRoute(builder: (context) {
                                    return KakaoMapTest();
                                  }));
                            },
                            child: Row(
                              children: <Widget>[
                                Container(
                                  child: Container(
                                    child: Icon(
                                      Icons.add_location_alt_outlined,
                                      color: Colors.black,
                                      size: MediaQuery.of(context).size.height *
                                          0.12 *
                                          0.4,
                                    ),
                                    margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                  ),
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
                              ],
                            ),
                          ),
                        ],
                      ),
                      height: MediaQuery.of(context).size.height * 0.12,
                      width: MediaQuery.of(context).size.width,
                      margin:
                          const EdgeInsets.only(left: 100, right: 0, top: 15),
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            bottomLeft: Radius.circular(30),
                          ),
                          color: Colors.grey[200],
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 15,
                              spreadRadius: 1,
                              offset: Offset(4, 4),
                            ),
                            BoxShadow(
                              color: Colors.white,
                              blurRadius: 15,
                              spreadRadius: 1,
                              offset: Offset(-4, -4),
                            )
                          ]),
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
                                  MaterialPageRoute(builder: (context) {
                                    return ShowDisasterMsg();
                                  }));
                            },
                            child: Row(
                              children: <Widget>[
                                Container(
                                  child: Container(
                                    child: Icon(
                                      Icons.sms_failed_outlined,
                                      color: Colors.black,
                                      size: MediaQuery.of(context).size.height *
                                          0.12 *
                                          0.4,
                                    ),
                                    margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                  ),
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
                              ],
                            ),
                          ),
                        ],
                      ),
                      height: MediaQuery.of(context).size.height * 0.12,
                      width: MediaQuery.of(context).size.width,
                      margin:
                          const EdgeInsets.only(left: 100, right: 0, top: 15),
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            bottomLeft: Radius.circular(30),
                          ),
                          color: Colors.grey[200],
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 15,
                              spreadRadius: 1,
                              offset: Offset(4, 4),
                            ),
                            BoxShadow(
                              color: Colors.white,
                              blurRadius: 15,
                              spreadRadius: 1,
                              offset: Offset(-4, -4),
                            )
                          ]),
                    ),
                  ],
                ),
              ))),
    );
  }
}
