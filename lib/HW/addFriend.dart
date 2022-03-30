import 'package:flutter/material.dart';

class AddFreindPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("나중에 친구찿기페이지가 될 아이"),
        ),
        body: Center(
          child: MaterialButton(
            onPressed: () { Navigator.pop(context); },
            child: Text("친구목록 화면으로 돌아가기"),

          ),
        )
    );
  }
}
