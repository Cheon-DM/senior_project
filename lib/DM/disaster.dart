import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'message.dart';

void callMessage() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyAs4QaED_5xj6hvFySG8RhqqvJAMk05gKY",
      appId: "1:1051877983471:android:70919ed3a8496500f6871a",
      messagingSenderId: "1051877983471",
      projectId: "testing-7e550",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'disaster scroll',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>{
  bool loading = false;

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  void initState(){
    super.initState();
    getList();
  }

  Future<void> getList() async {
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