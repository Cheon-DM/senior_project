import 'package:flutter/material.dart';

class ActionGuide extends StatefulWidget {
  @override
  _ActionGuideState createState() => _ActionGuideState();
}

class _ActionGuideState extends State<ActionGuide> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: '행동지침1',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text('행동지침'),
          ),
          drawer: Drawer(
            child: ListView(
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
          ),
        ));
  }
}
