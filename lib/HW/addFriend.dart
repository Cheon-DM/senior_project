

import 'dart:math';
import 'package:senior_project/DM/findShelter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:senior_project/HS/myPage.dart';
import 'package:get/get.dart';

import 'friendlist.dart';




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


  late Future<QuerySnapshot> futureSearchResults;


  final userref=FirebaseFirestore.instance.collection('user');



  emptyTextFormField(){
    searchTextEditingController.clear();

  }


  controlSearching(str) {
    print(str);
    print("입력");
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




  displayNoSearchResultScreen(context){
    final Orientation orientation = MediaQuery.of(context).orientation;
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

                            await FirebaseFirestore.instance.collection('user').doc('${snapshot.data!.docs[index]['uid']}')
                                .collection('FriendAdmin').doc(user!.uid).set({
                              'otheruser': 1,
                              'email': user.email,
                              'name':cUserName,
                              'uid': user.uid,
                              'friend_lat': cUserLat,
                              'friend_lng': cUserLng,
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

  /////////////////////////////////////////////////////////////


String getEmail = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //키보드 밀려올라감 방지
      resizeToAvoidBottomInset : false,

      appBar: AppBar(
        backgroundColor: const Color(0xff6157DE),
        elevation: 5,
        title: Text(
          "나의 친구관리",
          style: TextStyle(
            fontFamily: 'Leferi',
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: (){
            // Get.to(MainPage());
            Get.offAll(() => Menu());
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
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
                                final cUser=FirebaseFirestore.instance.collection('user').doc(user!.uid);
                                await cUser.get().then(
                                        (value){
                                      cUserName = value['userName'];
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
                                  'uid': user.uid
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





/*
class Tlqkf extends StatefulWidget {
  @override
  _TlqkfState createState() => _TlqkfState();
}

class _TlqkfState extends State<Tlqkf> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchPageHeader(),
      body: futureSearchResults == null ? displayNoSearchResult() :
      displayUsersFoundScreen(),
    );
  }

  String searchText='';

  TextEditingController searchController = TextEditingController();

  late Stream<QuerySnapshot<Map<String, dynamic>>> futureSearchResults;

  emptyTextFormField() {
    searchController.clear();
  }

  controlSearching(str) {
    print(str);
    searchText =str;
    Stream<QuerySnapshot<Map<String, dynamic>>> allUser = FirebaseFirestore.instance.collection(
        "user")
        .where("email", isEqualTo: str).snapshots();
    setState(() {
      futureSearchResults = allUser;
    });
  }

  AppBar searchPageHeader() {
    return AppBar(
      backgroundColor: Colors.black,
      title: TextFormField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: 'Search here...',
          filled: true,
          prefixIcon: Icon(Icons.person_pin),
          suffixIcon: IconButton(icon: Icon(Icons.clear, color: Colors.white,),
            onPressed: emptyTextFormField,),

        ),
        style: TextStyle(
            color: Colors.white
        ),
        onFieldSubmitted: controlSearching,


      ),
    );
  }

  displayUsersFoundScreen() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection(
            "user")
            .where("email", isEqualTo: searchText).snapshots(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          final messages = snapshot.data!.docs;
          List<Text> messageWidget =[];


            final messageText = messages[0]['email'];
            final messageSender = messages[0]['userName'];
            print(messageSender);
            print(messageText);

          return dmdkr();

        });
  }

  Widget dmdkr(){

    return Expanded(
      child: Text('hello')
    );

  }


}

class UserResult extends StatelessWidget{
  final User eachUser;
  UserResult(this.eachUser);

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: EdgeInsets.all(3),
    );
  }

}


displayNoSearchResult() {

}
*/





/////리스트에 넣어보자!!!!


