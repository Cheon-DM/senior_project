import 'package:flutter/material.dart';

class DisasterSMS extends StatefulWidget {
  @override
  _DisasterSMSState createState() => _DisasterSMSState();
}

class _DisasterSMSState extends State<DisasterSMS> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('재난문자'),
      ),

        body : Column(
            children: <Widget>[
              Container(
                color : Colors.red,
                width : 150,
                height : 100,
                margin : const EdgeInsets.all(8.0),
              ),

              Container(
                color : Colors.amber,
                width : 150,
                height : 100,
                margin : const EdgeInsets.all(8.0),
              ),
              Container(
                color : Colors.blue,
                width : 150,
                height : 100,
                margin : const EdgeInsets.all(8.0),
              ),
              Container(
                color : Colors.yellow,
                width : 150,
                height : 100,
                margin : const EdgeInsets.all(8.0),
              ),
            ]
        ),

    );
  }
}