import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:senior_project/HS/action_guide.dart';
import 'package:senior_project/HS/disaster_sms.dart';
import 'package:senior_project/HS/location_sharing.dart';
import 'package:senior_project/HS/loginPage.dart';
import 'package:senior_project/HS/myPage.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('메인페이지'),),
      body: Center(
        child: Column(
          children: [
            OutlinedButton(
                onPressed: () {
                  Get.to(PreLoginPage());
                },
                child: Text("내 정보")
            ),
            SizedBox(
              height: 200,
              width: 200,
              child: ElevatedButton(
                  onPressed: () {

                  },
                  child: Text("내 주변 대피소")
              ),
            ),
            OutlinedButton(
                onPressed: () {
                  Get.to(LocationSharing());
                },
                child: Text("위치공유")
            ),
            OutlinedButton(
                onPressed: () {
                  Get.to(ActionGuide());
                },
                child: Text("행동지침")
            ),
            OutlinedButton(
                onPressed: () {
                  Get.to(DisasterSMS());
                },
                child: Text("재난문자")
            ),
            OutlinedButton(
                onPressed: () {

                },
                child: Text("빈칸><")
            ),
          ],
        )
      )

    );
  }
}