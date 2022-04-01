import 'package:flutter/material.dart';

class Requested extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          title: Text("혜원 친구목록 페이지"),
        ),
        body: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 10),
              color: Colors.blue,
              width: size.width,
              height: 50,
              child: SizedBox.expand(child: Text("친구 관리",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                ),)),
            ),
            Row(
              children: <Widget>[
                GestureDetector(
                    child: Container(
                      padding: EdgeInsets.only(top: 13),
                      color: Colors.blue,
                      width: size.width * 0.5,
                      height: 50,
                      child: SizedBox.expand(child: Text("친구",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                          )
                      )),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    }
                ),
                Container(
                  padding: EdgeInsets.only(top: 13),
                  color: Colors.white,
                  width: size.width * 0.5,
                  height: 50,
                  child: SizedBox.expand(child: Text("받은 요청",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                      )
                  )),
                )
              ],
            ),


          ],
        ));
  }
}
