import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:senior_project/HW/addFriend.dart';
import 'package:senior_project/HW/requestedFriend.dart';
import 'package:get/get.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';
import '../HS/myPage.dart';

var name='';
final user = FirebaseAuth.instance.currentUser;

void _sendName() async {

  final userData = await FirebaseFirestore.instance
      .collection("user").doc(user!.uid).collection('FriendAdmin')
      .where('otheruser', isEqualTo: 1)
      .get();
  print(userData);
}




class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset : false,

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
            Navigator.push(context,
                MaterialPageRoute(builder: (context) {
                  return MyPage();
                }));
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


                  //_sendName(); 이거 왜 넣은거지??

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
                      onPressed: ()async {
                        await FirebaseFirestore.instance.collection('user').doc(uid)
                            .collection('FriendAdmin').doc(user!.uid).update({
                          'friend': 0,
                        });
                        await FirebaseFirestore.instance.collection('user').doc(user!.uid)
                            .collection('FriendAdmin').doc(uid).update({
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


   Future<List> getUserLocation(friendLat, friendLng) async {
    var kakaoGeoUrl = Uri.parse('https://dapi.kakao.com/v2/local/geo/coord2address.json?x=$friendLng&y=$friendLat&input_coord=WGS84');
    var kakaoGeo = await http.get(kakaoGeoUrl, headers: {"Authorization": "KakaoAK c4238e0ca7c5003d25786b53e52b1062"});

    String addr = kakaoGeo.body;
    var addrData = jsonDecode(addr);

    print(addrData['documents'][0]['address']['address_name']);
    //print(addrData['documents'][1]['road_address']['address_name']);


    var address = addrData['documents'][0]['address']['address_name'];
    //var roadAddress = addrData['documents'][1]['road_address']['address_name'];

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
                    if(snapshot.hasData == false){
                      return CircularProgressIndicator();
                    }
                    else{
                      List ll =snapshot.data as List;
                      return Column(
                        children: [
                          SizedBox(height: 30),
                          Text(
                            name + '님의 위치\n\n'
                            +'지번주소: ' +ll[0]
                            +'\n',
                            //+'도로명주소: ' +ll[1],
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
                                      .showSnackBar(SnackBar(content: Text('친구위치확인.')));
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

                            ],
                          )
                        ],
                      );
                    }
                  },
                  future: getUserLocation(friendLat, friendLng)),
                )


              );

         }
    );}

  Widget build(BuildContext context) {

      return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("user").doc(user!.uid).collection('FriendAdmin')
              .where('friend', isEqualTo: 1)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        return Scaffold(
            body: ListView.separated(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (BuildContext context, int index) {
            return ExpansionTile(
              iconColor: Colors.grey,
              collapsedIconColor: Colors.grey,
              textColor: Colors.black,
              collapsedTextColor: Colors.black,
              collapsedBackgroundColor: Colors.white,
              backgroundColor: Colors.grey[200],


              leading: snapshot.data!.docs[index]['userPhotoUrl'] == null?
              Image.asset('assets/neoguleman.jpeg',
                fit: BoxFit.contain,
                height: 200,)
                  :Image.network(snapshot.data!.docs[index]['userPhotoUrl'],fit: BoxFit.cover),
              /*Icon(
                Icons.account_circle,
                size: 40,
              ),*/
              title: Text(
                snapshot.data!.docs[index]['name'],
              ),
              subtitle: Text(
                  snapshot.data!.docs[index]['email']
              ),
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

                    title: ElevatedButton(
                      onPressed: ()async{
                        print('확인하기');
                        //getData();
                        print(snapshot.data!.docs[index]['friend_lat']);
                        showFriendLocation(context, snapshot.data!.docs[index]['name'],snapshot.data!.docs[index]['friend_lat'],snapshot.data!.docs[index]['friend_lng']);
                      }, child: Text(
                      '친구위치 확인하기',
                      style: TextStyle(
                        fontFamily: 'Leferi',
                        fontSize: 13,
                        color: Colors.black,
                      ),),
                    ),

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
                                  context, snapshot.data!.docs[index]['name'], snapshot.data!.docs[index]['email'],snapshot.data!.docs[index]['uid']);
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
    );
  }
}
