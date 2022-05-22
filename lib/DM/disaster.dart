import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:senior_project/HS/mainpage.dart';
import 'message.dart';

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
  bool loading = false;

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  void initState(){
    super.initState();
    getList();
  }

  Future<void> getList() async {
    update();
    crawling();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff6157DE),
        elevation: 0,
        title: Text(
            "재난문자",
          style: TextStyle(
            fontFamily: 'Leferi',
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: (){
            // Get.to(MainPage());
            Get.offAll(() => MainPage());
          },
          icon: Icon(
              Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
          ),
          SizedBox(
            height: 50.0,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: firebaseFirestore.collection("disaster_message").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting){
                return CircularProgressIndicator();
              }
              return SizedBox(
                height: MediaQuery.of(context).size.height*0.8,
                child: ListView.builder(
                  reverse: true,
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (ctx, index) => Container(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: Text('NO. ${snapshot.data!.docs[index]['BBS_ORDR']}',
                              style: TextStyle(
                                  fontFamily: 'Leferi',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                              ),
                            alignment: Alignment.centerLeft,
                          ),
                          Container(
                            child: Text('${snapshot.data!.docs[index]['CONT']}',
                                style: TextStyle(
                                    fontFamily: 'Leferi',
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal
                                ),
                              ),
                            alignment: Alignment.centerLeft,
                          ),
                          Container(
                            child: Text('DATE : ${snapshot.data!.docs[index]['FRST_REGIST_DT']}',
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
          )
        ],
      )
    );
  }
}