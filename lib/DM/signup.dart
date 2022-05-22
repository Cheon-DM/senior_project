import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:senior_project/DM/signup_complete.dart';

import '../HW/login.dart';

class signup extends StatefulWidget {
  @override
  _signupState createState() => _signupState();
}

class _signupState extends State<signup> {
  final _formkey = GlobalKey<FormState>();
  final _authentication = FirebaseAuth.instance;

  String userName = '';
  String userEmail = '';
  String userPassword = '';

  void _tryValidation() {
    final isValid = _formkey.currentState!.validate();
    if (isValid) {
      _formkey.currentState!.save();
    }
  }

  void _sendName()async{
    final user =FirebaseAuth.instance.currentUser;
    final userData= await FirebaseFirestore.instance.collection('user').doc(user!.uid).get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff6157DE),
        elevation: 0,
        title: Text(
          "회원가입",
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
            Get.offAll(() => login());
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(50),
        child: Form(
          key: _formkey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(height: 50),
                TextFormField(
                  key: ValueKey(1),
                  //닉네임 키: 1
                  validator: (value) {
                    //value 는 사용자가 입력한것 인자값
                    if (value!.isEmpty) {
                      return '이름 입력안됨';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    userName = value!;
                  },
                  onChanged: (value) {
                    userName = value!;
                  },
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                      icon: Icon(Icons.accessibility),
                      labelText: "닉네임",
                      hintText: 'Username',
                      border: OutlineInputBorder()),
                ),
                Container(height: 10),
                TextFormField(
                  key: ValueKey(2),
                  //아이디 키: 2
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return '제대로된 이메일 주소 입력';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    userEmail = value!;
                  },
                  onChanged: (value) {
                    userEmail = value!;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      icon: Icon(Icons.person),
                      labelText: "아이디",
                      hintText: 'ID',
                      border: OutlineInputBorder()),
                ),
                Container(height: 10),
                TextFormField(
                  obscureText: true,
                  key: ValueKey(3),
                  //비밀번호 키: 3
                  validator: (value) {
                    if (value!.isEmpty || value.length < 6) {
                      return '비번 6글자 이상 입력해라';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    userPassword = value!;
                  },
                  onChanged: (value) {
                    userPassword = value!;
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      icon: Icon(Icons.vpn_key),
                      labelText: "비밀번호",
                      hintText: 'Password',
                      border: OutlineInputBorder()),
                ),
                Container(height: 10),
                TextFormField(
                  obscureText: true,
                  key: ValueKey(4),
                  //비밀번호 확인 키: 4
                  validator: (value) {
                    if (value != userPassword) {
                      return '비번이 일치하지 않는구나';
                    } else if (value!.isEmpty) {
                      return '입력해라';
                    }
                    return null;
                  },

                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      icon: Icon(Icons.vpn_key_outlined),
                      labelText: "비밀번호 확인",
                      hintText: 'Password',
                      border: OutlineInputBorder()),
                ),
                Container(height: 200),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child:ElevatedButton(
          onPressed: () async {
            _tryValidation();

            final newUser =
            await _authentication.createUserWithEmailAndPassword(
                email: userEmail, password: userPassword);

            await FirebaseFirestore.instance.collection('user').doc(newUser.user!.uid)
                .set({
              'userName' : userName,
              'email' : userEmail
            });


            if (newUser.user == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('제대로된 입력 필요')));
            }

            Navigator.push(context,
                MaterialPageRoute(builder: (context) {
                  return signup_complete(userName);
                }));
          },
          child: Container(
            padding: EdgeInsets.only(top: 9),
            height: 50,
            color: const Color(0xff6157DE),
            child: Text(
              '회원가입하기',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Leferi',
                  fontWeight: FontWeight.bold,
                  color: Colors.white
              ),
            ),
          ),
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.white),
            backgroundColor:
            MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.disabled)) {
                return Colors.grey;
              } else {
                return Color(0xff6157de);
              }
            }
            ),
          ),
        ),
      ),
    );
  }
}

/*

class signup extends StatelessWidget {
  final _formkey = GlobalKey<FormState>();
  final _authentication = FirebaseAuth.instance;

  String userName = '';
  String userEmail = '';
  String userPassword = '';

  void _tryValidation() {
    final isValid = _formkey.currentState!.validate();
    if (isValid) {
      _formkey.currentState!.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("회원가입"),
      ),
      body: Padding(
        padding: EdgeInsets.all(50),
        child: Form(
          key: _formkey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(height: 50),
                TextFormField(
                  key: ValueKey(1),
                  //닉네임 키: 1
                  validator: (value) { //value 는 사용자가 입력한것 인자값
                    if (value!.isEmpty) {
                      return '이름 입력안됨';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    userName = value!;
                  },
                  onChanged: (value) {
                    userName = value!;
                  },
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                      icon: Icon(Icons.accessibility),
                      labelText: "닉네임",
                      hintText: 'Username',
                      border: OutlineInputBorder()
                  ),
                ),
                Container(height: 10),
                TextFormField(
                  key: ValueKey(2),
                  //아이디 키: 2
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return '제대로된 이메일 주소 입력';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    userEmail = value!;
                  },
                  onChanged: (value) {
                    userEmail = value!;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      icon: Icon(Icons.person),
                      labelText: "아이디",
                      hintText: 'ID',
                      border: OutlineInputBorder()
                  ),
                ),
                Container(height: 10),
                TextFormField(
                  obscureText: true,
                  key: ValueKey(3),
                  //비밀번호 키: 3
                  validator: (value) {
                    if (value!.isEmpty || value.length < 6) {
                      return '비번 6글자 이상 입력해라';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    userPassword = value!;
                  },
                  onChanged: (value) {
                    userPassword = value!;
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      icon: Icon(Icons.vpn_key),
                      labelText: "비밀번호",
                      hintText: 'Password',
                      border: OutlineInputBorder()
                  ),
                ),
                Container(height: 10),
                TextFormField(
                  obscureText: true,
                  key: ValueKey(4),
                  //비밀번호 확인 키: 4
                  validator: (value) {
                    if (value != userPassword) {
                      return '비번이 일치하지 않는구나';
                    }
                    else if (value!.isEmpty) {
                      return '입력해라';
                    }
                    return null;
                  },

                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      icon: Icon(Icons.vpn_key_outlined),
                      labelText: "비밀번호 확인",
                      hintText: 'Password',
                      border: OutlineInputBorder()
                  ),
                ),
                Container(height: 100),
                Container(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    onPressed: () async {
                      _tryValidation();
                      try {
                        final newUser = await _authentication
                            .createUserWithEmailAndPassword(
                            email: userEmail, password: userPassword);

                        if(newUser.user !=null){
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return signup_complete();
                          }));
                        }

                      }catch(e){
                        print(e);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('제대로된 입력 필요'))
                        );
                        
                      }
                    },
                    child: Text("회원가입하기"),
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      backgroundColor: MaterialStateProperty.resolveWith((
                          states) {
                        if (states.contains(MaterialState.disabled)) {
                          return Colors.grey;
                        }
                        else {
                          return Color(0xff6157de);
                        }
                      }
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}


 */