import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senior_project/mainpage.dart';
import '../friendsManage/friendlist.dart';
import '../login/login.dart';
import '../provider/LocateData.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  late Stream myStream;
  XFile? _pickImage;
  final auth = FirebaseAuth.instance; //원래 _authentication
  late LocateProvider _locateProvider =
      Provider.of<LocateProvider>(context, listen: false);
  final user = FirebaseAuth.instance.currentUser;
  final ref = FirebaseFirestore.instance.collection('user');
  var userPhoto = "";
  String photourl = "";
  var usernameee = "";
  bool _isloading = true;

  void initState() {
    super.initState();
    myStream = _prepare();
  }

  Stream<void> _prepare() async* {
    final cUser = ref.doc(user!.uid);
    await cUser.get().then((value) {
      userPhoto = value['userPhotoUrl'];
      usernameee = value['userName'];
    });
    if (userPhoto != "") {
      var ref1 =
          await FirebaseStorage.instance.ref().child("profile/${user!.uid}");
      await ref1.getDownloadURL().then((loc) => setState(() => photourl = loc));
    }
    _isloading = false;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: myStream,
        builder: (context, snapshot) {
          if (_isloading) {
            return Center(
              child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Stack(
                    fit: StackFit.expand,
                    children: const [
                      CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 5,
                      ),
                    ],
                  ),
              ),
            );
          }
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: const Color(0xff6157DE),
              elevation: 0,
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
                  Navigator.of(context, rootNavigator: true).pop();
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
            ),
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //프로필 사진
                  userPhoto == ""
                      ? Card(
                        child: Image.asset(
                            //기본이미지
                            'assets/images/neoguleman.jpeg',
                            fit: BoxFit.contain,
                            height: 200,
                            width: 200,
                          ),
                    elevation: 3,
                      )
                      : Card(
                        child: Image.network(
                            //사용자 지정 이미지
                            photourl,
                            fit: BoxFit.cover,
                            height: 200,
                            width: 200,
                          ),
                    elevation: 3,
                      ),

                  //사용자 정보 ui
                  //사용자 닉네임
                  Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 10, bottom: 0),
                    child: Column(
                      children: <Widget>[
                        Text(usernameee,
                            style: TextStyle(
                              fontFamily: 'Leferi',
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                            ),
                        ),
                      ],
                    ),
                  ),

                  //사용자 이메일
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    alignment: Alignment.center,
                    child: Column(
                      children: <Widget>[
                        Text(
                            user!.email.toString(),
                          style: TextStyle(
                            fontFamily: 'Leferi',
                            fontSize: 15,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      //프로필 변경
                      Container(
                        width: 200,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                            ),
                            side: BorderSide(
                              width: 1,
                              color: Color(0xff6157DE),
                            ),
                          ),
                          onPressed: () {
                            _locateProvider.locateMe();
                            showModalBottomSheet<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: ElevatedButton.icon(
                                        style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                            width: 0.0,
                                            color:
                                            Colors.white.withOpacity(0.0),
                                          ),
                                          backgroundColor: Colors.deepPurple
                                              .withOpacity(0.0),
                                          shadowColor: Colors.deepPurple
                                              .withOpacity(0.0),
                                        ),
                                        onPressed: () async {
                                          _getPhoto();
                                        },
                                        icon: Icon(
                                          Icons.camera_alt_rounded,
                                          color: Colors.black,
                                          size: 50,
                                        ),
                                        label: Text(
                                          "사진 불러오기",
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: OutlinedButton.icon(
                                        style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                            width: 0.0,
                                            color:
                                            Colors.black.withOpacity(0.0),
                                          ),
                                          backgroundColor: Colors.deepPurple
                                              .withOpacity(0.0),
                                          shadowColor: Colors.deepPurple
                                              .withOpacity(0.0),
                                        ),
                                        onPressed: () async {
                                          _getBasicImage();
                                        },
                                        icon: Icon(
                                          Icons.co_present_outlined,
                                          color: Colors.black,
                                          size: 50,
                                        ),
                                        label: Text(
                                          "기본 이미지로 변경",
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text(
                            "프로필 사진 변경하기",
                            style: TextStyle(
                              fontFamily: 'Leferi',
                              color: Color(0xff6157DE),
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),

                      //나의 친구관리 버튼
                      Container(
                        width: 200,
                        child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                              ),
                              side: BorderSide(
                                width: 1,
                                color: Color(0xff6157DE),
                              ),
                            ),
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
                                color: Color(0xff6157DE),
                                fontSize: 13,
                              ),
                            )),
                      ),

                      //메인페이지 버튼
                      Container(
                        width: 200,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                            ),
                            side: BorderSide(
                              width: 1,
                              color: Color(0xff6157DE),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                          child: Text(
                            "메인페이지",
                            style: TextStyle(
                              fontFamily: 'Leferi',
                              color: Color(0xff6157DE),
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              child: GestureDetector(
                onTap: () {
                  auth.signOut();
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return (LogIn());
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
        });
  }

  _getPhoto() async {
    var downloadURL = "";
    final pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, maxWidth: 650, maxHeight: 100);

    if (pickedFile == null) return;
    setState(() {
      _pickImage = pickedFile;
    });

    final storageRef = FirebaseStorage.instance;
    TaskSnapshot task = (await storageRef
        .ref()
        .child("profile/${user!.uid}")
        .putFile(File(_pickImage!.path)));

    downloadURL = await task.ref.getDownloadURL();
    var doc = ref.doc(user!.uid);
    doc.update({'userPhotoUrl': downloadURL});

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => MainPage()),
      (route) => false,
    );
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return MyPage();
    }));
  }

  _getBasicImage() async {
    ref.doc(user!.uid).update({'userPhotoUrl': ""});
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return MyPage();
    }));
  }
}
