import 'package:flutter/material.dart';

class signup extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("회원가입"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                  labelText: "닉네임",
                  hintText: 'Username',
                  border: OutlineInputBorder()
              ),
            ),
            TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  labelText: "아이디",
                  hintText: 'ID',
                  border: OutlineInputBorder()
              ),
            ),
            TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  labelText: "비밀번호",
                  hintText: 'Password',
                  border: OutlineInputBorder()
              ),
            ),
            TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  labelText: "비밀번호 확인",
                  hintText: 'Password',
                  border: OutlineInputBorder()
              ),
            ),
          ],
        ),
      ),
    );
  }

}
