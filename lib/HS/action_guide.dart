import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

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
              // Get.to(MainPage());
              Get.offAll(() => MainPage());
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),

        body: Padding(
          padding: EdgeInsets.all(0),
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
                      ExpansionTile(
                        title: Text(
                          "메뉴1",
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
                              "메뉴1.1",
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
