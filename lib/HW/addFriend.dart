

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:senior_project/HS/myPage.dart';
import 'package:get/get.dart';

import 'friendlist.dart';


/*class UserResult extends StatelessWidget{
  final User eachUser;
  UserResult(this.eachUser);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3),
      child: Container(

      ),
    )
  }


}*/



class AddFriend extends StatefulWidget {
  @override
  _AddFriendState createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {
  ///////////////////////////////////////////////
  TextEditingController searchTextEditingController = TextEditingController();


  late Future<QuerySnapshot> futureSearchResults;


  final userref=FirebaseFirestore.instance.collection('user');

  var hello; // 나중에 지우기
  //final showemail = FirebaseFirestore.instance.collection('user').doc('user');


  void _sendName()async{ //나중에 지우기

    final userData= await FirebaseFirestore.instance.collection('user').doc('uLOQtwoojbeKhYj0oglECxvRKnO2').get();
    hello = userData.data()!['email'];
    print(hello);
  }







  emptyTextFormField(){
    searchTextEditingController.clear();
  }


  controlSearching(str) {
    print(str);
   // Future<QuerySnapshot> allUsers = userref.where('email', isEqualTo: str).get();
    var hel = userref.where('email', isEqualTo: str).get();
    if(hel!=null){print(hel);}
    setState((){
     // futureSearchResults = allUsers;
      //if(hel!=null){print(hel);}
    });
  }


/*
  displayNoSearchResultScreen(context){
    final Orientation orientation = MediaQuery.of(context).orientation;
  }

  displayUsersFoundScreen(){
    return FutureBuilder(
        future: futureSearchResults,
        builder: (context, snapshot){
          if(snapshot.hasData==false){
            return CircularProgressIndicator();
          }

          List<UserResult> searchUserResult = [];
          snapshot.data.
        }
    );
  }
*/





  /////////////////////////////////////////////////////////////




  @override
  Widget build(BuildContext context) {
    return Scaffold(

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
      body: Padding(
        padding: EdgeInsets.all(10),
        child: TextFormField(
            controller: searchTextEditingController,
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
              suffixIcon: IconButton(icon: Icon(Icons.clear, color: Colors.grey[700]),
                onPressed: (){
                  emptyTextFormField();
                  _sendName();
                },


                //emptyTheTextFormField,
              ),

            ),
            onFieldSubmitted: controlSearching,
        ),
      ),
    );
  }
}







