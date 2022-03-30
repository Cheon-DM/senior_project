import 'package:flutter/material.dart';

class AddFriend extends StatefulWidget {
  @override
  _AddFriendState createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchPageHeader(),
    );
  }
}

TextEditingController searchTextEditingController = TextEditingController();

AppBar searchPageHeader() {
  return AppBar(
    title: TextFormField(
        controller: searchTextEditingController,
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: TextStyle(
            color: Colors.white,
          ),
          enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.deepPurpleAccent)),
          filled: true,
          prefixIcon: Icon(Icons.person_pin, color: Colors.green, size: 20),
          suffixIcon: IconButton(icon: Icon(Icons.clear, color: Colors.amberAccent),
            onPressed: (){},

            //emptyTheTextFormField,
          ),

        )
    ),
  );
}

displayNoSearchResultScreen(context){
  final Orientation orientation = MediaQuery.of(context).orientation;
}