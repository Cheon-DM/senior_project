import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../info/myPage.dart';

class Requested extends StatelessWidget {
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
        ));
  }
}



final user =FirebaseAuth.instance.currentUser;


class FreindList extends StatefulWidget {
  @override
  _FreindListState createState() => _FreindListState();
}

class _FreindListState extends State<FreindList> {
  @override

  final user =FirebaseAuth.instance.currentUser;

  Widget build(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("user").doc(user!.uid).collection('FriendAdmin')
          .where('otheruser', isEqualTo: 1)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        return Scaffold(
            body: ListView.separated(
              itemCount:snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  iconColor: Colors.grey,
                  textColor: Colors.black,

                  leading: Icon(
                    Icons.account_circle,
                    size: 40,
                  ),
                  title: Text(
                     snapshot.data!.docs[index]['name'],

                  ),
                  subtitle: Text(snapshot.data!.docs[index]['email']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: ()async{

                          print('${snapshot.data!.docs[index]['email']}');

                          var cUserName='';
                          double cUserLat=0;
                          double cUserLng=0;
                          var userPhoto;
                          final cUser=FirebaseFirestore.instance.collection('user').doc(user!.uid);
                          await cUser.get().then(
                                  (value){
                                    cUserName = value['userName'];
                                    cUserLat=value['my_lat'];
                                    cUserLng=value['my_lng'];
                                    userPhoto = value['userPhotoUrl'];
                              }
                          );



                          await FirebaseFirestore.instance.collection('user').doc(user!.uid)
                              .collection('FriendAdmin').doc('${snapshot.data!.docs[index]['uid']}').update({
                            'otheruser': 0,
                            'friend' : 1
                          });

                          await FirebaseFirestore.instance.collection('user').doc('${snapshot.data!.docs[index]['uid']}')
                              .collection('FriendAdmin').doc(user!.uid).update({
                            //'otheruser': 1,
                            'friend' : 1,
                            'email': user!.email,
                            'name':cUserName,
                            'uid': user!.uid,
                            'friend_lat': cUserLat,
                            'friend_lng': cUserLng,
                            'userPhotoUrl' : userPhoto
                          });

                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text('친구 요청 수락.')));
                        },
                        child: Text(
                          '수락',
                          style: TextStyle(
                            fontFamily: 'Leferi',
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        onPressed: () async{

                          await FirebaseFirestore.instance.collection('user').doc('${snapshot.data!.docs[index]['uid']}')
                              .collection('FriendAdmin').doc(user!.uid).delete();
                          await FirebaseFirestore.instance.collection('user').doc(user!.uid)
                              .collection('FriendAdmin').doc('${snapshot.data!.docs[index]['uid']}').delete();
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text('친구 요청 거절.')));
                        },
                        child: Text(
                          '거절',
                          style: TextStyle(
                            fontFamily: 'Leferi',
                          ),
                        ),
                      )
                    ],
                  )
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
