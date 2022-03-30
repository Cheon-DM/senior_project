
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'addFriend.dart';


class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          title: Text("혜원 친구목록 페이지"),
        ),
        body: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 10),
              color: Colors.blue,
              width: size.width,
              height: 50,
              child: SizedBox.expand(child: Text("친구 관리",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                ),)),
            ),
            Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 13),
                  color: Colors.white,
                  width: size.width * 0.5,
                  height: 50,
                  child: SizedBox.expand(child: Text("친구",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                      )
                  )),
                ),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.only(top: 13),
                    color: Colors.blue,
                    width: size.width * 0.5,
                    height: 50,
                    child: SizedBox.expand(child: Text("받은 요청",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                        )
                    )),
                  ),
                  onTap: (){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('나중에 다른페이지로 넘어갑니다')));
                  },
                )
              ],
            ),
            Expanded(child: Stack(
              children: [
                FreindList(),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)=>AddFriend()));}, child: Text("친구추가각"),)
                )
              ],
            ) ),

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
  var nameList = ['박혜원', '천다미', '정혜선', '호롤로', '홀롤로로', '호롤롤로로롤', '혜원띠','디미띠','혜선ㄸㅣ'];
  var emailList = ['혜원@hongik', '다미@hongik', '혜선@hongik','','','','','',''];

  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.separated(
          itemCount: nameList.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: (){


              },

              child: ListTile(
                contentPadding: EdgeInsets.fromLTRB(12, 10, 12, 10),
                leading: Icon(Icons.account_circle,
                  size: 40,
                ),
                title: Text(nameList[index]),
                subtitle: Text(emailList[index]),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Divider(
              height: 10,
              color: Colors.grey,
            );
          },));
  }
}
