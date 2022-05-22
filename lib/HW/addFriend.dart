import 'package:flutter/material.dart';
import 'package:senior_project/HS/myPage.dart';
import 'package:get/get.dart';

import 'friendlist.dart';


class AddFriend extends StatefulWidget {
  @override
  _AddFriendState createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {
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
                onPressed: (){},

                //emptyTheTextFormField,
              ),

            )
        ),
      ),
    );
  }
}

TextEditingController searchTextEditingController = TextEditingController();

displayNoSearchResultScreen(context){
  final Orientation orientation = MediaQuery.of(context).orientation;
}