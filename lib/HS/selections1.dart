import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Selections1 extends StatelessWidget {
  const Selections1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        children: [
          Expanded(
              child: Container(
            color: Colors.red,
          ),
          flex: 1,
          ),
          Expanded(
              child: Container(
            color: Colors.green,
          ),
          flex: 2,
          ),
        ],
      )
    );
  }
}