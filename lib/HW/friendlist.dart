import 'package:flutter/material.dart';
import 'package:senior_project/HW/addFriend.dart';
import 'package:senior_project/HW/requestedFriend.dart';
import 'package:get/get.dart';

import '../HS/myPage.dart';

class Menu extends StatelessWidget {
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
              Container(
                padding: EdgeInsets.only(top: 13),
                color: Colors.white,
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
                    ),
                  ),
                ),
              ),
              InkWell(
                child: Container(
                  padding: EdgeInsets.only(top: 13),
                  color: const Color(0xff6157DE),
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
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('나중에 다른페이지로 넘어갑니다')));
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Requested()));
                },
              )
            ],
          ),
          Expanded(
            child: Stack(
              children: [
                FreindList(),
                Align(
                  alignment: Alignment.bottomCenter,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddFriend()));
          },
          child: Container(
            height: 50,
            color: const Color(0xff6157DE),
            child: Text(
              "친구추가",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'Leferi',
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FreindList extends StatefulWidget {
  @override
  _FreindListState createState() => _FreindListState();
}

class _FreindListState extends State<FreindList> {
  @override
  var nameList = [
    '박혜원',
    '천다미',
    '정혜선',
    '박소정',
    '홀롤로로',
    '호롤롤로로롤',
    '혜원띠',
    '디미띠',
    '혜선ㄸㅣ'
  ];
  var emailList = [
    '혜원@hongik',
    '다미@hongik',
    '혜선@hongik',
    '소정@hongik',
    '',
    '',
    '',
    '',
    ''
  ];

  void showProfile(context, name, email) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  SizedBox(height: 30),
                  Icon(Icons.account_circle, size: 50),
                  SizedBox(height: 30),
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Leferi',
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    email,
                    style: TextStyle(
                      fontSize: 10,
                      fontFamily: 'Leferi',
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '마지막 위치',
                    style: TextStyle(
                      fontSize: 9,
                      fontFamily: 'Leferi',
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('닫기')),
                ],
              ),
            ),
          );
        });
  }

  void showDelete(context, name, email) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              child: Container(
            width: 400,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              children: [
                SizedBox(height: 30),
                Text(
                  name + '님을 정말로 삭제 하시겠습니까??',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text('삭제되었습니다.')));
                      },
                      child: Text(
                        '확인',
                        style: TextStyle(
                          fontFamily: 'Leferi',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        '취소',
                        style: TextStyle(
                          fontFamily: 'Leferi',
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ));
        });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.separated(
      itemCount: nameList.length,
      itemBuilder: (BuildContext context, int index) {
        return ExpansionTile(
          iconColor: Colors.grey,
          collapsedIconColor: Colors.grey,
          textColor: Colors.black,
          collapsedTextColor: Colors.black,
          collapsedBackgroundColor: Colors.white,
          backgroundColor: Colors.grey[200],

          leading: Icon(
            Icons.account_circle,
            size: 40,
          ),
          title: Text(
            nameList[index],
          ),
          subtitle: Text(emailList[index]),
          //backgroundColor: Colors.amber,
          children: <Widget>[
            /*
            Divider(
              height: 3,
              color: Colors.white,
              indent: 20,
              endIndent: 20,
            ),
             */
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: ListTile(
                //contentPadding: EdgeInsets.fromLTRB(12, 10, 12, 10),
                tileColor: Colors.white,

                title: Text('마지막 위치'),

                subtitle: TextFormField(
                  decoration: InputDecoration(
                      prefixText: '메모',
                      hintText: 'memo',
                      border: OutlineInputBorder()),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: 5),
                    ElevatedButton(
                        onPressed: () {
                          showDelete(
                              context, nameList[index], emailList[index]);
                        },
                        child: Text(
                          '친구 삭제',
                          style: TextStyle(
                            fontFamily: 'Leferi',
                            fontSize: 13,
                            color: Colors.black,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                        )),
                    SizedBox(width: 10)
                  ],
                ),
              ),
            ),
          ],
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(
          height: 0,
          color: Colors.grey,
        );
      },
    ));
  }
}
