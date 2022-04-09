import 'package:flutter/material.dart';

class login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('로그인'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(100),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                    icon: Icon(Icons.person),
                    hintText: 'Username', border: OutlineInputBorder()),
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                    icon: Icon(Icons.vpn_key),
                    hintText: 'Password', border: OutlineInputBorder()),
              ),
              SizedBox(height: 20),
              Text('아직 회원이 아니신가요?'),

              GestureDetector(
                  onTap: () {ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('회원가입으로 이동.')));},
                  child: Text(
                    "회원가입하기",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  ))
            ],
          ),

        ),
        bottomNavigationBar: BottomAppBar(
          child: GestureDetector(
            onTap: (){ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('로그인 완료.')));},
            child: Container(
              padding: EdgeInsets.only(top: 9),
              height: 50,
              color: Colors.blue,
              child: Text('로그인',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white
                ),),
            ),
          ),
        ),
    );
  }
}
