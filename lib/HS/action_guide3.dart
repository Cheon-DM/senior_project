import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senior_project/Provider/GuideData.dart';
import 'mainpage.dart';


const List<Widget> buttons = <Widget>[
  Text('자연재난행동요령'),
  Text('사회재난행동요령'),
  Text('생활안전행동요령'),
  Text('비상대비행동요령'),
];

class ActionGuide3 extends StatefulWidget {
  @override
  _ActionGuideState3 createState() => _ActionGuideState3();
}

class _ActionGuideState3 extends State<ActionGuide3> {
  //List<bool> _selections1 = List.generate(4, (index) => false);
  List<bool> _selections1 = <bool>[true, false, false, false];
  FocusNode focusButton1 = FocusNode();
  FocusNode focusButton2 = FocusNode();
  FocusNode focusButton3 = FocusNode();
  FocusNode focusButton4 = FocusNode();
  late List<FocusNode> focusToggle;

  late GuideDataProvider guideDataProvider = Provider.of<GuideDataProvider>(context, listen: false);
  List<String> NationalList = ['태풍', '홍수', '호우', '강풍', '대설', '한파', '풍랑', '황사', '폭염', '가뭄', '지진', '지진해일', '해일', '산사태', '화산폭발'];

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
                            selectedBorderColor: const Color(0xff6157DE).withOpacity(0.0),
                            selectedColor: Colors.black,
                            fillColor: Colors.grey.withOpacity(0.2),
                            color: Colors.black,
                            constraints: BoxConstraints(
                              minWidth: MediaQuery.of(context).size.width * 0.25,
                              minHeight: MediaQuery.of(context).size.height * 0.05,
                            ),
                          ),

                          if(_selections1[0] == true)...[
                            SafeArea(
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                      child : ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: 15,
                                        itemBuilder: (cxt, index) =>
                                            ExpansionTile(
                                              title: Text(NationalList[index]),
                                              children: <Widget>[
                                                Row(
                                                  children: [Expanded(
                                                        child: ListView.builder(
                                                            shrinkWrap: true,
                                                            physics: NeverScrollableScrollPhysics(),
                                                            itemCount: guideDataProvider.getNationalGuideStep(index),
                                                            itemBuilder: (_, idx) =>
                                                              FutureBuilder(
                                                                future: guideDataProvider.getNational(index),
                                                                builder: (context, snp) {
                                                                  return ListTile(
                                                                    title: Text(
                                                                      "1.1. 비상시 행동요령",
                                                                      style: TextStyle(
                                                                          fontFamily: 'Leferi',
                                                                          fontSize: 15
                                                                      ),
                                                                    ),
                                                                    onTap: (){
                                                                      showDialog(
                                                                          context: context,
                                                                          builder: (BuildContext context){
                                                                            return AlertDialog(
                                                                              scrollable: true,
                                                                              content: Column(
                                                                                children: <Widget>[
                                                                                  for (String i in context.read<GuideDataProvider>().statement)
                                                                                    Text(i),
                                                                                ],
                                                                              ),
                                                                              actions: [
                                                                                TextButton(
                                                                                    onPressed: (){
                                                                                      Navigator.of(context).pop();
                                                                                    },
                                                                                    child: Text("Ok")
                                                                                )
                                                                              ],
                                                                            );
                                                                          });
                                                                    },
                                                                  );
                                                                }
                                                              )
                                                        )
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                      )
                                  )
                                ],
                              ),
                            )


                            //화생방 피해대비 행동요령
                          ]else if(_selections1[1] == true)...[
                            SafeArea(
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                      child : ListView(
                                        shrinkWrap: true,
                                        children: <Widget>[
                                          //1.1. 비상시 행동요령
                                          ExpansionTile(
                                            title: Text(
                                              "1.1. 비상시 행동요령",
                                              style: TextStyle(
                                                  fontFamily: 'Leferi',
                                                  fontSize: 15
                                              ),
                                            ),
                                            children: <Widget>[
                                              ListTile(
                                                title : Text(
                                                  "1.1.1. 비상시 정부대응",
                                                  style: TextStyle(
                                                      fontFamily: 'Leferi',
                                                      fontSize: 15
                                                  ),
                                                ),
                                                onTap: (){

                                                },
                                              ),
                                              ListTile(
                                                title : Text(
                                                  "1.1.2. 비상시 국민행동요령",
                                                  style: TextStyle(
                                                      fontFamily: 'Leferi',
                                                      fontSize: 15
                                                  ),
                                                ),
                                                onTap: (){

                                                },
                                              ),
                                              ListTile(
                                                title : Text(
                                                  "1.1.3. 국가동원령 선포",
                                                  style: TextStyle(
                                                      fontFamily: 'Leferi',
                                                      fontSize: 15
                                                  ),
                                                ),
                                                onTap: (){

                                                },
                                              ),
                                              ListTile(
                                                title : Text(
                                                  "1.1.4. 배급제 안내",
                                                  style: TextStyle(
                                                      fontFamily: 'Leferi',
                                                      fontSize: 15
                                                  ),
                                                ),
                                                onTap: (){

                                                },
                                              ),
                                              ListTile(
                                                title : Text(
                                                  "1.1.5. 신고 요령",
                                                  style: TextStyle(
                                                      fontFamily: 'Leferi',
                                                      fontSize: 15
                                                  ),
                                                ),
                                                onTap: (){

                                                },
                                              )
                                            ],
                                          )
                                        ],
                                      )
                                  )
                                ],
                              ),
                            )


                            //화생방 피해대비 행동요령
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