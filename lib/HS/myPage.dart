import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senior_project/HS/mainpage.dart';
import '../HW/friendlist.dart';
import '../HW/login.dart';
import '../Provider/LocateData.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';


class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  XFile ? _pickImage;
  final _authentication = FirebaseAuth.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  late LocateProvider _locateProvider = Provider.of<LocateProvider>(context,listen: false);
  final _user = FirebaseAuth.instance.currentUser;
  var userPhoto="";
  String photourl="";
  var d000="";




  void initState() {
    super.initState();
    _prepare();

  }

  void _prepare() async{
    var ref1 =await FirebaseStorage.instance.ref().child("profile/${_user?.uid}");
    await ref1.getDownloadURL().then((loc) => setState(() =>  photourl= loc));
    final cUser=FirebaseFirestore.instance.collection('user').doc(_user!.uid);
    await cUser.get().then(
            (value){
          userPhoto = value['userPhotoUrl'];

        }
    );
  }


  @override
  Widget build(BuildContext context) {


    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("user")
            .where('uid', isEqualTo: user!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

        return Scaffold(

          resizeToAvoidBottomInset : false,

          appBar: AppBar(
            backgroundColor: const Color(0xff6157DE),
            elevation: 5,
            title: Text(
              "내 정보",
              style: TextStyle(
                fontFamily: 'Leferi',
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                      return MainPage();
                    }));
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
          body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

               userPhoto == null ? Image.asset('assets/neoguleman.jpeg',
                fit: BoxFit.contain,
                height: 200,)
                :Image.network(photourl,fit: BoxFit.cover),


                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("사용자닉네임",
                            style: TextStyle(fontWeight: FontWeight.bold)
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[Text(auth.currentUser!.email.toString())],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Wrap(
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.center,
                    //mainAxisAlignment: MainAxisAlignment.center,
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //프로필 변경
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        child: OutlinedButton(
                            onPressed: () {
                              _locateProvider.locateMe();
                              showModalBottomSheet<void>(
                                  context: context,
                                  builder: (BuildContext context){
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          height: 20,
                                        ),
                                        ElevatedButton(
                                            onPressed: () async {
                                              _getPhoto();
                                              },
                                            child: Text('사진 불러오기')),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        ElevatedButton(
                                            onPressed: () async {_getBasicImage();

                                              },
                                            child: Text('기본이미지로 변경하기'))
                                      ],
                                    );
                                  });
                            },
                            child: Text(
                              "프로필 사진 변경하기",
                              style: TextStyle(
                                fontFamily: 'Leferi',
                                color: const Color(0xff6157DE),
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                      ),
                      //나의 친구관리 버튼
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        child: OutlinedButton(
                            onPressed: () {
                              _locateProvider.locateMe();
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return Menu();
                              }));
                            },
                            child: Text(
                              "나의 친구관리",
                              style: TextStyle(
                                fontFamily: 'Leferi',
                                color: const Color(0xff6157DE),
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                      ),

                      //메인페이지 버튼
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return MainPage();
                            }));
                          },
                          child: Text(
                            "메인페이지",
                            style: TextStyle(
                              fontFamily: 'Leferi',
                              color: const Color(0xff6157DE),
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
          ),
          bottomNavigationBar: BottomAppBar(
            child: GestureDetector(
              onTap: () {
                _authentication.signOut();
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return (login());
                }));
              },
              child: Container(
                padding: EdgeInsets.only(top: 9),
                height: 50,
                color: const Color(0xff6157DE),
                child: Text(
                  "로그아웃",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Leferi',
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ),
        );
      }
    );
  }
  _getPhoto() async{
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery,
      maxWidth: 650, maxHeight: 100
    );
    
    if (pickedFile == null) return;
    setState(() {
      _pickImage = pickedFile;
    });

    final storageRef = FirebaseStorage.instance;
    TaskSnapshot task = (await storageRef.ref().child("profile/${_user?.uid}").putFile(File(_pickImage!.path))) as TaskSnapshot;

    if(task !=null){
      var downloadURL = await task.ref.getDownloadURL();
      var doc =
          FirebaseFirestore.instance.collection('user').doc(_user?.uid);
      doc.update({
        'userPhotoUrl' : downloadURL
      });

    }
    Navigator.push(context,
        MaterialPageRoute(builder: (context) {
          return MyPage();
        }));
  }
  _getBasicImage() async{
    FirebaseFirestore.instance.collection('user').doc(_user?.uid).update({
      'userPhotoUrl' : null
    });
    Navigator.push(context,
        MaterialPageRoute(builder: (context) {
          return MyPage();
        }));

  }


}



