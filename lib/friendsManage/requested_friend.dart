import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'friendlist.dart';

class Requested extends StatelessWidget {
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
                Row(
                  children: <Widget>[
                    GestureDetector(
                        child: Container(
                          padding: EdgeInsets.only(top: 13),
                          width: size.width * 0.5,
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xff6157DE),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                          ),
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
                          Navigator.of(context, rootNavigator: true).pop();
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Menu()));
                        }),
                    Container(
                      padding: EdgeInsets.only(top: 13),
                      width: size.width * 0.5,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                      ),
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

class FreindList extends StatefulWidget {
  @override
  _FreindListState createState() => _FreindListState();
}

class _FreindListState extends State<FreindList> {
  @override
  final user = FirebaseAuth.instance.currentUser;
  final ref = FirebaseFirestore.instance.collection("user");

  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: ref
            .doc(user!.uid)
            .collection('FriendAdmin')
            .where('otheruser', isEqualTo: 1)
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
                      color: Color(0xff6157DE),
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
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xff6157DE),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          elevation: 0,
                        ),

                        onPressed: () async {
                          var currentUserName = '';
                          double currentUserLat = 0;
                          double currentUserLng = 0;
                          var userPhoto;
                          final cUser = FirebaseFirestore.instance
                              .collection('user')
                              .doc(user!.uid);
                          await cUser.get().then((value) {
                            currentUserName = value['userName'];
                            currentUserLat = value['my_lat'];
                            currentUserLng = value['my_lng'];
                            userPhoto = value['userPhotoUrl'];
                          });

                          await ref
                              .doc(user!.uid)
                              .collection('FriendAdmin')
                              .doc('${snapshot.data!.docs[index]['uid']}')
                              .update({'otheruser': 0, 'friend': 1});

                          await ref
                              .doc('${snapshot.data!.docs[index]['uid']}')
                              .collection('FriendAdmin')
                              .doc(user!.uid)
                              .update({
                            'friend': 1,
                            'email': user!.email,
                            'name': currentUserName,
                            'uid': user!.uid,
                            'friend_lat': currentUserLat,
                            'friend_lng': currentUserLng,
                            'userPhotoUrl': userPhoto
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('친구 요청 수락.')));
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
                        style: ElevatedButton.styleFrom(
                          primary: Colors.grey[200],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          elevation: 0,
                        ),

                        onPressed: () async {
                          await ref
                              .doc('${snapshot.data!.docs[index]['uid']}')
                              .collection('FriendAdmin')
                              .doc(user!.uid)
                              .delete();
                          await ref
                              .doc(user!.uid)
                              .collection('FriendAdmin')
                              .doc('${snapshot.data!.docs[index]['uid']}')
                              .delete();
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('친구 요청 거절.')));
                        },
                        child: Text(
                          '거절',
                          style: TextStyle(
                            fontFamily: 'Leferi',
                            color: Colors.black,
                          ),
                        ),
                      )
                    ],
                  ));
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
