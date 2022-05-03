import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyAs4QaED_5xj6hvFySG8RhqqvJAMk05gKY",
        appId: "1:1051877983471:android:70919ed3a8496500f6871a",
        messagingSenderId: "1051877983471",
        projectId: "testing-7e550",
    ),
  );
  runApp(_Disaster());
}

class _Disaster extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Testing',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey
      ),
      home: DisasterPage(title: 'page',),
    );
  }
}

class DisasterPage extends StatefulWidget{
  const DisasterPage({ Key? key,  required this.title}) : super(key: key);
  final String title;

  @override
  _DisasterPageState createState() => _DisasterPageState();
}

class _DisasterPageState extends State<DisasterPage> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  int _counter = 0;

  void _incrementCounter(){
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title)
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text(
              'dfjaldjls'
            ),
            Text(
                'data'
            ),
            // DB에서 데이터 모두 불러오기
            ElevatedButton(
                onPressed: (){
                  String disaster = "";
                  String name = "test2";
                  firebaseFirestore.collection("disaster_message").get().then((value){
                    value.docs.forEach(
                          (element) {
                            print(element.data());
                            },
                    );
                    },
                  );
                  },
            child: Text("read button"))
          ],
        )
      ),
    );

  }
}