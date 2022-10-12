import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senior_project/HS/mainpage.dart';
import 'package:senior_project/Provider/DisasterMsgData.dart';

class ShowDisasterMsg extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'disaster scroll',
      home: ShowDisasterList(),
    );
  }
}

class ShowDisasterList extends StatefulWidget {
  ShowDisasterList({Key? key}) : super(key: key);

  @override
  _ShowDisasterListState createState() => _ShowDisasterListState();
}

class _ShowDisasterListState extends State<ShowDisasterList>{
  final List<String> _AreaList = ['시도선택', '강원도', '경기도', '경상남도', '경상북도', '광주광역시', '대구광역시', '대전광역시', '부산광역시', '서울특별시', '세종특별자치시', '울산광역시', '인천광역시', '전라남도', '전라북도', '제주특별자치도', '충청남도', '충청북도'];
  String _selectArea = '시도선택';
  int _selectAreaNum = 0;
  bool loading = false;
  late DisasterMsgProvider _msgProvider = Provider.of<DisasterMsgProvider>(context, listen: false);

  final ref = FirebaseFirestore.instance.collection("disaster_message");

  @override
  void initState(){
    super.initState();
    getList();
  }

  Future<void> getList() async {
    _msgProvider.update();
    _msgProvider.crawling();
    Timer(Duration(seconds: 1), () {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: const Color(0xff6157DE),
          elevation: 5,
          title: Text(
            "재난문자",
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

        body: Column(
          children: [
            DropdownButton(
              value: _selectArea,
              items: _AreaList.map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (dynamic value) {
                setState(() {
                  _selectArea = value;
                  _selectAreaNum = _AreaList.indexOf(_selectArea);
                });
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
            ),
            SizedBox(
              height: 0.0,
            ),
            FutureBuilder(
                future: getList(),
                builder: (context, snap) {
                  return StreamBuilder<QuerySnapshot>(
                      stream: ref.orderBy("CREATE_DT", descending: true).snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting){
                          return CircularProgressIndicator();
                        }
                        else if(_selectAreaNum == 0){
                          return SizedBox(
                            height: MediaQuery.of(context).size.height*0.9,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (ctx, index) => Container(
                                padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                                child: Container(
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        child: Text('NO. ${snapshot.data!.docs[index]['MD101_SN']}',
                                          style: TextStyle(
                                              fontFamily: 'Leferi',
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        alignment: Alignment.centerLeft,
                                      ),
                                      Container(
                                        child: Text('${snapshot.data!.docs[index]['MSG_CN']}',
                                          style: TextStyle(
                                              fontFamily: 'Leferi',
                                              fontSize: 17,
                                              fontWeight: FontWeight.normal
                                          ),
                                        ),
                                        alignment: Alignment.centerLeft,
                                      ),
                                      Container(
                                        child: Text('DATE : ${snapshot.data!.docs[index]['CREATE_DT']}',
                                          style: TextStyle(
                                              fontFamily: 'Leferi',
                                              fontSize: 10,
                                              fontWeight: FontWeight.normal
                                          ),
                                        ),
                                        alignment: Alignment.centerRight,
                                      ),
                                    ],
                                  ),
                                  //메세지 카드
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        blurRadius: 5,
                                        spreadRadius: 1,
                                        offset: Offset(0,5),
                                      )
                                    ],
                                  ),
                                  padding: EdgeInsets.all(15),
                                ),
                                color: Colors.grey[200],
                              ),
                            ),
                          );
                        }
                        else {
                          return StreamBuilder<QuerySnapshot>(
                              stream: ref.where("LOC", isEqualTo: _selectAreaNum).snapshots(),
                              builder: (context, snap) {
                                return SizedBox(
                                  height: MediaQuery.of(context).size.height*0.9,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snap.data!.docs.length,
                                    itemBuilder: (ctx, index) => Container(
                                      padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                                      child: Container(
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              child: Text('NO. ${snap.data!.docs[index]['MD101_SN']}',
                                                style: TextStyle(
                                                    fontFamily: 'Leferi',
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              alignment: Alignment.centerLeft,
                                            ),
                                            Container(
                                              child: Text('${snap.data!.docs[index]['MSG_CN']}',
                                                style: TextStyle(
                                                    fontFamily: 'Leferi',
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.normal
                                                ),
                                              ),
                                              alignment: Alignment.centerLeft,
                                            ),
                                            Container(
                                              child: Text('DATE : ${snap.data!.docs[index]['CREATE_DT']}',
                                                style: TextStyle(
                                                    fontFamily: 'Leferi',
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.normal
                                                ),
                                              ),
                                              alignment: Alignment.centerRight,
                                            )
                                          ],
                                        ),
                                        //메세지 카드
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(15)),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.5),
                                              blurRadius: 5,
                                              spreadRadius: 1,
                                              offset: Offset(0,5),
                                            )
                                          ],
                                        ),
                                        padding: EdgeInsets.all(15),
                                      ),
                                      color: Colors.grey[200],
                                    ),
                                  ),
                                );
                              }
                          );
                        }
                      }
                  );
                }
            )
          ],
        )
    );
  }
}