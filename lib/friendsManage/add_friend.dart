import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddFriend extends StatefulWidget {
  @override
  _AddFriendState createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {

  final ref = FirebaseFirestore.instance.collection('user');
  final user = FirebaseAuth.instance.currentUser;

  TextEditingController searchTextEditingController = TextEditingController();
  Future<QuerySnapshot>? futureSearchResult;

  static double checkDouble(dynamic value) {
    if (value is String) {
      return double.parse(value);
    } else {
      return value;
    }
  }

  controlSearch(str){
    Future<QuerySnapshot> searchUser = ref.where("email", isEqualTo: str).get();
    setState(() {
      if(str!=user!.email) {
        futureSearchResult = searchUser;
      }
      else{
        futureSearchResult =null;
      }
    });

  }

  displayNoSearchResultScreen() {
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Icon(Icons.group, color: Colors.grey, size: 150),
            Text("검색 결과 없다는 화면을 만들고싶은데....혜서니가 만들어 주겟징....ㅜㅜㅜ"),
          ],
        ),
      ),
    );
  }

  displayUserFound(){
    return FutureBuilder<QuerySnapshot>(
        future:  futureSearchResult,
        builder: (context, snapshot) {
          if (!snapshot.hasData){
            return CircularProgressIndicator();
          }
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
                                var isAlreadyFriend = (await ref.doc(user!.uid)
                                    .collection('FriendAdmin')
                                    .doc(snapshot.data!.docs[index]['uid']).get());
                                if(!isAlreadyFriend.exists){
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('친구요청되었습니다.')));
                                  var currentUserName = '';
                                  double ulat=0;
                                  double ulng=0;
                                  double currentUserLat = 0;
                                  double currentUserLng = 0;
                                  final currentUser = ref.doc(user!.uid);
                                  await currentUser.get().then((value) {
                                    currentUserName = value['userName'];
                                    ulat = value['my_lat'];
                                    ulng = value['my_lng'];
                                  });
                                  currentUserLat=checkDouble(ulat);
                                  currentUserLng=checkDouble(ulng);
                                  var userPhoto;
                                  await currentUser.get().then((value) {
                                    userPhoto = value['userPhotoUrl'];
                                  });

                                  await ref
                                      .doc(user!.uid)
                                      .collection('FriendAdmin')
                                      .doc('${snapshot.data!.docs[index]['uid']}')
                                      .set({
                                    'me': 1,
                                    'friend':0
                                  }); //사용자가 친구요청을 보냄 => me: 1이됨 (이것은 나중에 친구거절을 눌렀을시 0이됨) 근데 얘가 왜필요한지 의문...

                                  await ref
                                      .doc('${snapshot.data!.docs[index]['uid']}')
                                      .collection('FriendAdmin')
                                      .doc(user!.uid)
                                      .set({
                                    'otheruser': 1,
                                    'friend':0,
                                    'email': user!.email,
                                    'name': currentUserName,
                                    'uid': user!.uid,
                                    'friend_lat': currentUserLat,
                                    'friend_lng': currentUserLng,
                                    'userPhotoUrl': userPhoto
                                  });
                                  // 친구요청을 받음 => otheruser: 1이됨 친구요청 리스트에 이걸로 목록 나타냄
                                }
                                else{
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('이미 친구이거나 요청되었습니다.')));
                                }
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
                controller: searchTextEditingController,
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
                    icon: Icon(Icons.clear, color: Colors.grey[700]),
                    onPressed: () {
                      searchTextEditingController.clear();
                    },
                  ),
                ),
                textInputAction: TextInputAction.search,
                onFieldSubmitted: controlSearch,
              ),

            ),
          ],
        ),
      ),
      body: futureSearchResult == null
          ? displayNoSearchResultScreen()
          : displayUserFound());

  }

}

//////새로운 위젯... 전에 쓰던거 일단 남겨둠

class FindFriend extends StatefulWidget {
  final String received;

  const FindFriend(this.received);

  @override
  _FindFriendState createState() => _FindFriendState();
}

class _FindFriendState extends State<FindFriend> {
  final ref = FirebaseFirestore.instance.collection('user');
  final user = FirebaseAuth.instance.currentUser;

  static double checkDouble(dynamic value) {
    if (value is String) {
      return double.parse(value);
    } else {
      return value;
    }
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: ref.where("email", isEqualTo: widget.received).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
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
                            double ulat=0;
                            double ulng=0;
                            double currentUserLat = 0;
                            double currentUserLng = 0;
                            final currentUser = ref.doc(user!.uid);
                            await currentUser.get().then((value) {
                              currentUserName = value['userName'];
                              ulat = value['my_lat'];
                              ulng = value['my_lng'];
                            });
                            currentUserLat=checkDouble(ulat);
                            currentUserLng=checkDouble(ulng);

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
                            });
                            // 친구요청을 받음 => otheruser: 1이됨 친구요청 리스트에 이걸로 목록 나타냄
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
