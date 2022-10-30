import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FindUser{
  late final String findname;
  late final String findingemail;

  FindUser({
    this.findingemail='',
    this.findname=''
  });

}

class AddFriend extends StatefulWidget {
  @override
  _AddFriendState createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {
  ///////////////////////////////////////////////
  TextEditingController searchTextEditingController = TextEditingController();


  Future<QuerySnapshot>? futureSearchResults;


  final userref=FirebaseFirestore.instance.collection('user');



  emptyTextFormField(){
    searchTextEditingController.clear();

  }


  controlSearching(str) {
    print(str);
    print("입력");

    Future<QuerySnapshot> allUsers = userref.where(
        'email', isGreaterThanOrEqualTo: str).get();
    setState(() {
      futureSearchResults = allUsers;
    });
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .where("email", isEqualTo: str)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          print("으악");
          return SizedBox(
            height: MediaQuery.of(context).size.height*0.9,
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (ctx, index) => Container(
                padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(' ${snapshot.data!.docs[index]['email']}',
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
        }
    );
  }

  displayNoSearchResultScreen(){
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
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("user")
            .where("email", isEqualTo: str)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          print("으아아아아아아아아아아아아아아아아아아아아아dkdk악");
          print(snapshot.data!.docs.length);
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
                            //Navigator.pop(context);
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text('친구요청되었습니다.')));

                            final user =FirebaseAuth.instance.currentUser;

                            var cUserName='';
                            double cUserLat=0;
                            double cUserLng=0;
                            final cUser=FirebaseFirestore.instance.collection('user').doc(user!.uid);
                            await cUser.get().then(
                                (value){
                                  cUserName = value['userName'];
                                  cUserLat=value['my_lat'];
                                  cUserLng=value['my_lng'];
                                }
                            );



                            await FirebaseFirestore.instance.collection('user').doc(user!.uid)
                                .collection('FriendAdmin').doc('${snapshot.data!.docs[index]['uid']}').set({
                              'me': 1
                            }); //사용자가 친구요청을 보냄 => me: 1이됨 (이것은 나중에 친구거절을 눌렀을시 0이됨) 근데 얘가 왜필요한지 의문...
                            //쓸모없으면 나중에 지우기

                            var userPhoto;
                            await cUser.get().then(
                                    (value){
                                  userPhoto = value['userPhotoUrl'];
                                }
                            );
                            await FirebaseFirestore.instance.collection('user').doc('${snapshot.data!.docs[index]['uid']}')
                                .collection('FriendAdmin').doc(user!.uid).set({
                              'otheruser': 1,
                              'email': user.email,
                              'name':cUserName,
                              'uid': user.uid,
                              'friend_lat': cUserLat,
                              'friend_lng': cUserLng,
                              'userPhotoUrl' : userPhoto
                            }); // 친구요청을 받음 => otheruser: 1이됨 친구요청 리스트에 이걸로 목록 나타냄

                            /*await FirebaseFirestore.instance.collection('user').doc(user!.uid)
                                .collection('FriendList');*/

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

  /////////////////////////////////////////////////////////////

String getEmail = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //키보드 밀려올라감 방지
      resizeToAvoidBottomInset : false,
      appBar: AppBar(
        title : Column(
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
                  enabledBorder:
                  UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: const Color(0xff6157DE))
                  ),
                  filled: true,
                  prefixIcon: Icon(Icons.person_pin, color: Colors.grey[700], size: 20),

                  suffixIcon: IconButton(icon: Icon(Icons.search, color: Colors.grey[700]),
                    onPressed: (){
                      print("살려줘어ㅓ어어어어어어어엉");
                      _buildbody(context, getEmail);
                      //emptyTextFormField();
                      /* Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                              return _buildbody(context, getEmail);
                            }));*/
                      // _buildbody(context, getEmail);
                      //_sendName();
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
      body: futureSearchResults == null ? displayNoSearchResultScreen() :
    FindFriend(getEmail),
    );
  }

}

class FindFriend extends StatefulWidget {
  final String received;
  const FindFriend(this.received);
 // print(widget.received);
  @override
  _FindFriendState createState() => _FindFriendState();
}


class _FindFriendState extends State<FindFriend> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("user")
            .where("email", isEqualTo: widget.received)
            .snapshots(),
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
                                //Navigator.pop(context);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(content: Text('친구요청되었습니다.')));

                                final user =FirebaseAuth.instance.currentUser;

                                var cUserName='';
                                var cUserLat='';
                                var cUserLng='';
                                final cUser=FirebaseFirestore.instance.collection('user').doc(user!.uid);
                                await cUser.get().then(
                                        (value){
                                      cUserName = value['userName'];
                                      cUserLat=value['my_lat'];
                                      cUserLng=value['my_lng'];
                                    }
                                );
                                var userPhoto;
                                await cUser.get().then(
                                        (value){
                                      userPhoto = value['userPhotoUrl'];
                                    }
                                );



                                await FirebaseFirestore.instance.collection('user').doc(user!.uid)
                                    .collection('FriendAdmin').doc('${snapshot.data!.docs[index]['uid']}').set({
                                  'me': 1
                                }); //사용자가 친구요청을 보냄 => me: 1이됨 (이것은 나중에 친구거절을 눌렀을시 0이됨) 근데 얘가 왜필요한지 의문...
                                //쓸모없으면 나중에 지우기

                                await FirebaseFirestore.instance.collection('user').doc('${snapshot.data!.docs[index]['uid']}')
                                    .collection('FriendAdmin').doc(user!.uid).set({
                                  'otheruser': 1,
                                  'email': user.email,
                                  'name':cUserName,
                                  'uid': user.uid,
                                  'friend_lat': cUserLat,
                                  'friend_lng': cUserLng,
                                  'userPhotoUrl' : userPhoto
                                }); // 친구요청을 받음 => otheruser: 1이됨 친구요청 리스트에 이걸로 목록 나타냄




                                /*await FirebaseFirestore.instance.collection('user').doc(user!.uid)
                                .collection('FriendList');*/

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

