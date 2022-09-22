import 'dart:html';

import 'package:flutter/material.dart';

import 'mainpage.dart';

const List<Widget> buttons = <Widget>[
  Text('비상사태 피해'),
  Text('핵/화생방 피해'),
  Text('인명/시설 피해'),
  Text('비상대비물자'),
];

class ActionGuide3 extends StatefulWidget {
  @override
  _ActionGuideState3 createState() => _ActionGuideState3();
}

class _ActionGuideState3 extends State<ActionGuide3> {
  //List<bool> _selections1 = List.generate(4, (index) => false);
  List<bool> _selections1 = <bool>[false, false, false, false];
  FocusNode focusButton1 = FocusNode();
  FocusNode focusButton2 = FocusNode();
  FocusNode focusButton3 = FocusNode();
  FocusNode focusButton4 = FocusNode();
  late List<FocusNode> focusToggle;


  @override
  void initState() {
    focusToggle = [
      focusButton1,
      focusButton2,
      focusButton3,
      focusButton4,
    ];
    super.initState();
  }

  @override
  void dispose() {
    focusButton1.dispose();
    focusButton2.dispose();
    focusButton3.dispose();
    focusButton4.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'action-guide3',
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
          child: AppBar(
            backgroundColor: const Color(0xff6157DE),
            elevation: 0,
            title: Text(
              "행동지침3",
              style: TextStyle(
                fontFamily: 'Leferi',
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return MainPage();
                }));
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
        ),
        body: SafeArea(
            child: Column(
          children: <Widget>[
            //상단 버튼부
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.93,
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      ToggleButtons(
                        isSelected: _selections1,
                        children: buttons,
                        onPressed: (int index) {
                          setState(() {
                            for (int i = 0; i < _selections1.length; i++) {
                              _selections1[i] = i == index;
                            }
                          });
                        },
                        borderWidth: 0,
                        selectedBorderColor:
                            const Color(0xff6157DE).withOpacity(0.0),
                        selectedColor: Colors.black,
                        fillColor: Colors.grey.withOpacity(0.2),
                        color: Colors.black,
                        constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width * 0.25,
                          minHeight: MediaQuery.of(context).size.height * 0.05,
                        ),
                      ),

                      if(_selections1[0] == true)...[
                        Text('나오니?1'),
                        //actionGuide처럼 좌측에 분류/오른쪽에 내용 만들기
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                child: ListView(
                                  children: <Widget>[

                                    ExpansionTile(
                                      title: Text("비상사태시 행동요령"),
                                      backgroundColor: Colors.grey[200],
                                      collapsedBackgroundColor: Color(0xff6157de),
                                      collapsedTextColor: Colors.white,
                                      textColor: Colors.black,
                                      iconColor: Colors.black,
                                      collapsedIconColor: Colors.white,

                                      children: <Widget>[
                                        ListTile(
                                          title: Text("비상시 행동요령"),
                                          //onTap:
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        )
                      ]else if(_selections1[1] == true)...[
                        Text('나오는구나!2'),
                      ]else if(_selections1[2] == true)...[
                        Text('나오는구나!3'),
                      ]else if(_selections1[3] == true)...[
                        Text('나오는구나!4'),
                      ]
                    ],
                  )
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }
}