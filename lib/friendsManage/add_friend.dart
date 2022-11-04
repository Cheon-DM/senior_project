import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddFriend extends StatefulWidget {
  @override
  _AddFriendState createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {
  TextEditingController searchTextEditingController = TextEditingController();
  Future<QuerySnapshot>? futureSearchResults;

  final ref = FirebaseFirestore.instance.collection('user');

  /*emptyTextFormField() {
    searchTextEditingController.clear();
  }*/ //사용 안함.. 나중에 한번에 지우고 싶을때 사용하기

  controlSearching(str) {
    Future<QuerySnapshot> allUsers =
        ref.where('email', isGreaterThanOrEqualTo: str).get();
    setState(() {
      futureSearchResults = allUsers;
    });
    return StreamBuilder<QuerySnapshot>(
        stream: ref.where("email", isEqualTo: str).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (ctx, index) => Container(
                padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          ' ${snapshot.data!.docs[index]['email']}',
                          style: TextStyle(
                              fontFamily: 'Leferi',
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(15),
                ),
                color: Colors.grey[200],
              ),
            ),
          );
        });
  }

  displayNoSearchResultScreen() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Text("search users"),
          ],
        ),
      ),
    );
  }

  _buildbody(BuildContext context, String str) {
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder<QuerySnapshot>(
        stream: ref.where("email", isEqualTo: str).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          // print(snapshot.data!.docs.length);
          return Scaffold(
              body: SafeArea(
            child: Stack(
              children: <Widget>[
                ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (ctx, index) => Container(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            color: Colors.red,
                            child: Text(
                              ' ${snapshot.data!.docs[index]['email']}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Leferi',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            alignment: Alignment.centerLeft,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('친구요청되었습니다.')));

                              var cUserName = '';
                              double cUserLat = 0;
                              double cUserLng = 0;
                              final cUser = ref.doc(user!.uid);
                              await cUser.get().then((value) {
                                cUserName = value['userName'];
                                cUserLat = value['my_lat'];
                                cUserLng = value['my_lng'];
                              });

                              await ref
                                  .doc(user!.uid)
                                  .collection('FriendAdmin')
                                  .doc('${snapshot.data!.docs[index]['uid']}')
                                  .set({
                                'me': 1
                              }); //사용자가 친구요청을 보냄 => me: 1이됨 (이것은 나중에 친구거절을 눌렀을시 0이됨) 근데 얘가 왜필요한지 의문...
                              //쓸모없으면 나중에 지우기

                              var userPhoto;
                              await cUser.get().then((value) {
                                userPhoto = value['userPhotoUrl'];
                              });
                              await ref
                                  .doc('${snapshot.data!.docs[index]['uid']}')
                                  .collection('FriendAdmin')
                                  .doc(user!.uid)
                                  .set({
                                'otheruser': 1,
                                'email': user.email,
                                'name': cUserName,
                                'uid': user.uid,
                                'friend_lat': cUserLat,
                                'friend_lng': cUserLng,
                                'userPhotoUrl': userPhoto
                              }); // 친구요청을 받음 => otheruser: 1이됨 친구요청 리스트에 이걸로 목록 나타냄
                            },
                            child: Text(
                              '친구요청',
                              style: TextStyle(
                                fontFamily: 'Leferi',
                              ),
                            ),
                          )
                        ],
                      ),
                      padding: EdgeInsets.all(15),
                    ),
                    color: Colors.grey[200],
                  ),
                ),
              ],
            ),
          ));
        });
  }

  String getEmail = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //키보드 밀려올라감 방지
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                //controller: searchTextEditingController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return '이메일 입력안됨';
                  }
                  return null;
                },
                onSaved: (value) {
                  getEmail = value!;
                },
                onChanged: (value) {
                  getEmail = value!;
                },
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    color: Colors.grey[700],
                  ),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: const Color(0xff6157DE))),
                  filled: true,
                  prefixIcon:
                      Icon(Icons.person_pin, color: Colors.grey[700], size: 20),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search, color: Colors.grey[700]),
                    onPressed: () {
                      _buildbody(context, getEmail);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return FindFriend(getEmail);
                      }));
                      //FindFriend(getEmail);
                    },

                    //emptyTheTextFormField,
                  ),
                ),
                //onFieldSubmitted: controlSearching,
              ),
            ),
          ],
        ),
      ),
      body: futureSearchResults == null
          ? displayNoSearchResultScreen()
          : FindFriend(getEmail),
    );
  }
}

//////새로운 위젯

class FindFriend extends StatefulWidget {
  final String received;

  const FindFriend(this.received);

  // print(widget.received);
  @override
  _FindFriendState createState() => _FindFriendState();
}

class _FindFriendState extends State<FindFriend> {
  final ref = FirebaseFirestore.instance.collection('user');
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: ref.where("email", isEqualTo: widget.received).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          print(widget.received);
          print("으아아아아아아아아아아아아아아아아아아아아아dkdk악");
          print(snapshot.data!.docs.length);
          return Scaffold(
              body: Stack(
            children: <Widget>[
              ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (ctx, index) => Container(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          color: Colors.red,
                          child: Text(
                            ' ${snapshot.data!.docs[index]['email']}',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Leferi',
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          alignment: Alignment.centerLeft,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('친구요청되었습니다.')));

                            var currentUserName = '';
                            double currentUserLat = 0;
                            double currentUserLng = 0;
                            final currentUser = ref.doc(user!.uid);
                            await currentUser.get().then((value) {
                              currentUserName = value['userName'];
                              currentUserLat = value['my_lat'];
                              currentUserLng = value['my_lng'];
                            });
                            var userPhoto;
                            await currentUser.get().then((value) {
                              userPhoto = value['userPhotoUrl'];
                            });

                            await ref
                                .doc(user!.uid)
                                .collection('FriendAdmin')
                                .doc('${snapshot.data!.docs[index]['uid']}')
                                .set({
                              'me': 1
                            }); //사용자가 친구요청을 보냄 => me: 1이됨 (이것은 나중에 친구거절을 눌렀을시 0이됨) 근데 얘가 왜필요한지 의문...
                            //쓸모없으면 나중에 지우기

                            await ref
                                .doc('${snapshot.data!.docs[index]['uid']}')
                                .collection('FriendAdmin')
                                .doc(user!.uid)
                                .set({
                              'otheruser': 1,
                              'email': user!.email,
                              'name': currentUserName,
                              'uid': user!.uid,
                              'friend_lat': currentUserLat,
                              'friend_lng': currentUserLng,
                              'userPhotoUrl': userPhoto
                            }); // 친구요청을 받음 => otheruser: 1이됨 친구요청 리스트에 이걸로 목록 나타냄
                          },
                          child: Text(
                            '친구요청',
                            style: TextStyle(
                              fontFamily: 'Leferi',
                            ),
                          ),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(15),
                  ),
                  color: Colors.grey[200],
                ),
              ),
            ],
          ));
        });
  }
}
