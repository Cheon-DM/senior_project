import 'package:flutter/material.dart';

class signup_complete extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : Text("회원가입완료"),
      ),
      body: Padding(
        padding: EdgeInsets.all(50),
        child: Column(
            children: <Widget>[
              Text(
                "회원가입이 완료되었습니다.",
                textAlign: TextAlign.start,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Container( height: 30 ),
              Row(
                children: <Widget>[
                  Text("닉네임"),
                  Container(width: 20,),
                  Text("천다미", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("님")
                ],
              ),
              Container( height: 10 ),
              Row(
                children: <Widget>[
                  Text("아이디"),
                  Container(width: 20,),
                  Text("adfhladsjfklasdjl"),
                ],
              ),
              Container(height: 100),
              Container(
                width: double.maxFinite,
                child: ElevatedButton(
                  onPressed: (){},
                  child: Text("로그인하기"),
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

        )
      ),
    );
  }
}