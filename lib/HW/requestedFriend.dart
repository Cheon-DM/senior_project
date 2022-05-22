import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../HS/myPage.dart';

class Requested extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff6157DE),
          elevation: 5,
          title: Text(
            "친구목록",
            style: TextStyle(
              fontFamily: 'Leferi',
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              // Get.to(MainPage());
              Get.offAll(() => MyPage());
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),
        body: Column(
          children: <Widget>[
            /*
            Container(
              padding: EdgeInsets.only(top: 10),
              color: const Color(0xff6157DE),
              width: size.width,
              height: 50,
              child: SizedBox.expand(
                child: Text(
                  "친구 관리",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Leferi',
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
             */

            Row(
              children: <Widget>[
                GestureDetector(
                    child: Container(
                      padding: EdgeInsets.only(top: 13),
                      color: const Color(0xff6157DE),
                      width: size.width * 0.5,
                      height: 50,
                      child: SizedBox.expand(
                        child: Text(
                          "친구",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Leferi',
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    }),
                Container(
                  padding: EdgeInsets.only(top: 13),
                  color: Colors.white,
                  width: size.width * 0.5,
                  height: 50,
                  child: SizedBox.expand(
                    child: Text(
                      "받은 요청",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Leferi',
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ));
  }
}
