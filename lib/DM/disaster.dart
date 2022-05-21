import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
        title: Text('Infinite scroll'),
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
                height: 400.0,
                child: ListView.builder(
                  reverse: true,
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (ctx, index) => Container(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Text('NO. ${snapshot.data!.docs[index]['BBS_ORDR']}',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          alignment: Alignment.centerLeft,
                        ),
                        Container(
                          child: Text('${snapshot.data!.docs[index]['CONT']}',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
                            ),
                          alignment: Alignment.centerLeft,
                        ),
                        Container(
                          child: Text('DATE : ${snapshot.data!.docs[index]['FRST_REGIST_DT']}',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.normal),
                            ),
                          alignment: Alignment.centerRight,
                        ),
                      ],
                    ),
                  ),),
              );
            }
          )
        ],
      )
    );
  }
}