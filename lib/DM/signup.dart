import 'package:flutter/material.dart';

class signup extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("회원가입"),
      ),
      body: Padding(
        padding: EdgeInsets.all(50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(height: 50),
            TextFormField(

              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                  icon: Icon(Icons.accessibility),
                  labelText: "닉네임",
                  hintText: 'Username',
                  border: OutlineInputBorder()
              ),
            ),
            Container(height: 10),
            TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  icon: Icon(Icons.person),
                  labelText: "아이디",
                  hintText: 'ID',
                  border: OutlineInputBorder()
              ),
            ),
            Container(height: 10),
            TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  icon: Icon(Icons.vpn_key),
                  labelText: "비밀번호",
                  hintText: 'Password',
                  border: OutlineInputBorder()
              ),
            ),
            Container(height: 10),
            TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  icon: Icon(Icons.vpn_key_outlined),
                  labelText: "비밀번호 확인",
                  hintText: 'Password',
                  border: OutlineInputBorder()
              ),
            ),
            Container(height: 100),
            Container(
              width: double.maxFinite,
              child: ElevatedButton(
                  onPressed: (){},
                  child: Text("회원가입하기"),
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    backgroundColor: MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.disabled)) { return Colors.grey; }
                      else { return Color(0xff6157de); }
                     }
                    ),
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
