import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:senior_project/friendsManage/requested_friend.dart';
import 'add_friend.dart';

var name = '';
final user = FirebaseAuth.instance.currentUser;

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color(0xff6157DE),
        elevation: 0,
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
            Navigator.of(context, rootNavigator: true).pop();
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Stack(
            children: [
              Container(
                color: Color(0xff6157DE),
                width: size.width,
                height: 50,
              ),
              //친구
              Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 13),
                    width: size.width * 0.5,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        )),
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

                  //받은 요청
                  InkWell(
                    child: Container(
                      padding: EdgeInsets.only(top: 13),
                      width: size.width * 0.5,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Color(0xff6157DE),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          )),
                      child: SizedBox.expand(
                        child: Text(
                          "받은 요청",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Leferi',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      //_sendName() 함수 삭제
                      Navigator.of(context, rootNavigator: true).pop();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Requested()));
                    },
                  )
                ],
              ),
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
            alignment: Alignment.center,
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
  String memo = "";
  final user = FirebaseAuth.instance.currentUser;
  final ref = FirebaseFirestore.instance.collection('user');

  @override
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

  void showDelete(context, name, email, uid) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            width: 400,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              children: [
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '님을 정말로 삭제 하시겠습니까??',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff6157DE),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        elevation: 0,
                      ),
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('user')
                            .doc(uid)
                            .collection('FriendAdmin')
                            .doc(user!.uid)
                            .update({
                          'friend': 0,
                        });
                        await FirebaseFirestore.instance
                            .collection('user')
                            .doc(user!.uid)
                            .collection('FriendAdmin')
                            .doc(uid)
                            .update({
                          'friend': 0,
                        });
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
                      width: 15,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.grey[200],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        elevation: 0,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        '취소',
                        style: TextStyle(
                          fontFamily: 'Leferi',
                          color: Colors.black,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<List> getUserLocation(friendLat, friendLng) async {
    var kakaoGeoUrl = Uri.parse(
        'https://dapi.kakao.com/v2/local/geo/coord2address.json?x=$friendLng&y=$friendLat&input_coord=WGS84');
    var kakaoGeo = await http.get(kakaoGeoUrl,
        headers: {"Authorization": "KakaoAK c4238e0ca7c5003d25786b53e52b1062"});
    String addr = kakaoGeo.body;
    var addrData = jsonDecode(addr);
    var address = addrData['documents'][0]['address']['address_name'];
    List<String> friendAdd = [address];
    return friendAdd;
  }

  void showFriendLocation(context, name, friendLat, friendLng) {
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
            child: FutureBuilder(
                builder: (context, snapshot) {
                  if (snapshot.hasData == false) {
                    return Center(
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: Stack(
                          fit: StackFit.expand,
                          children: const [
                            CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 5,
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    List ll = snapshot.data as List;
                    return Column(
                      children: [
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              '님의 위치',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          '지번주소: ' + ll[0] + '\n',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 10),

                        //친구위치 확인하기 > 확인 버튼
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.grey[200],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                elevation: 0,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('친구위치확인.')));
                              },
                              child: Text(
                                '확인',
                                style: TextStyle(
                                  fontFamily: 'Leferi',
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    );
                  }
                },
                future: getUserLocation(friendLat, friendLng)),
          ));
        });
  }

  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("user")
            .doc(user!.uid)
            .collection('FriendAdmin')
            .where('friend', isEqualTo: 1)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SizedBox(
                width: 100,
                height: 100,
                child: Stack(
                  fit: StackFit.expand,
                  children: const [
                    CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 5,
                    ),
                  ],
                ),
              ),
            );
          }
          return Scaffold(
              body: ListView.separated(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              // 친구목록 - 프로필사진 및 목록
              return ExpansionTile(
                iconColor: Colors.grey,
                collapsedIconColor: Colors.grey,
                textColor: Colors.black,
                collapsedTextColor: Colors.black,
                collapsedBackgroundColor: Colors.white,
                backgroundColor: Colors.white,
                leading: snapshot.data!.docs[index]['userPhotoUrl'] == ""
                    ? Image.asset(
                        'assets/images/neoguleman.jpeg',
                        fit: BoxFit.fitWidth,
                        width: 50,
                      )
                    : Image.network(
                        snapshot.data!.docs[index]['userPhotoUrl'],
                        fit: BoxFit.fitWidth,
                        width: 50,
                      ),
                /*Icon(
                Icons.account_circle,
                size: 40,
              ),
              ),*/
                // 친구목록 - 이름, 이메일
                title: Text(
                  snapshot.data!.docs[index]['name'],
                ),
                subtitle: Text(snapshot.data!.docs[index]['email']),
                children: <Widget>[
                  Container(
                    alignment: Alignment.bottomRight,
                    child: ListTile(
                      tileColor: Colors.white,

                      // 친구위치 확인하기 버튼
                      title: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xff6157DE),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          elevation: 0,
                        ),
                        onPressed: () async {
                          showFriendLocation(
                              context,
                              snapshot.data!.docs[index]['name'],
                              snapshot.data!.docs[index]['friend_lat'],
                              snapshot.data!.docs[index]['friend_lng']);
                        },
                        child: const Text(
                          '친구위치 확인하기',
                          style: TextStyle(
                            fontFamily: 'Leferi',
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 친구 삭제 버튼
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.grey[200],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              elevation: 0,
                            ),
                            onPressed: () {
                              showDelete(
                                  context,
                                  snapshot.data!.docs[index]['name'],
                                  snapshot.data!.docs[index]['email'],
                                  snapshot.data!.docs[index]['uid']);
                            },
                            child: Text(
                              '친구 삭제',
                              style: TextStyle(
                                fontFamily: 'Leferi',
                                fontSize: 13,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
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
        });
  }
}
