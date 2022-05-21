import 'package:flutter/material.dart';

class MainpageMenu extends StatelessWidget {
  const MainpageMenu({Key? key}) : super(key: key);

  @override

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 15.0,
            spreadRadius: 15.0,
            blurStyle:BlurStyle.normal,
            offset: Offset(5, 5),
          ),
        ], shape: BoxShape.rectangle,
          color: Colors.white),
      margin: EdgeInsets.fromLTRB(20, 8, 20, 10),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            bottomLeft: Radius.circular(30.0)),
      ),
    );
  }
}