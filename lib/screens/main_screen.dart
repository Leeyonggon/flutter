import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firstproject/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstproject/screens/chat_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstproject/add_image/add_image.dart';

class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({super.key});

  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  final _authentication = FirebaseAuth.instance;

  bool isSignupScreen = true;
  bool showspinner = false;
  final _formKey = GlobalKey<FormState>();
  String userName = '';
  String userEmail = '';
  String userPassword = '';
  File? userPickedimage;

  void pickedimage(File image) {
    userPickedimage = image;
  }

  void showAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: ((context) {
          return Dialog(
            backgroundColor: Colors.white,
            child: AddImage(// add_image.dart 클래스 호출 생성자
                pickedimage), // ()를 붙이지 않는 이유 => 메시지의 위치를 가리키고 있는 포인터만을 나타냄 메시지 호출 x
          );
        }));
  }

  void _tryValidation() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      body: ModalProgressHUD(
        inAsyncCall: showspinner,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            children: [
              Positioned(
                //배경
                top: 0,
                right: 0,
                left: 0,
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('image/first.jpg'), fit: BoxFit.fill),
                  ),
                  child: Container(
                    padding: EdgeInsets.only(top: 90, left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                              text: 'Welcome',
                              style: TextStyle(
                                  letterSpacing: 1.0,
                                  fontSize: 25,
                                  color: Colors.white),
                              children: [
                                TextSpan(
                                  text: isSignupScreen ? ' to Chat!' : ' YG',
                                  style: TextStyle(
                                      letterSpacing: 1.0,
                                      fontSize: 25,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )
                              ]),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          isSignupScreen
                              ? 'signup to continue'
                              : 'signin to continue',
                          style: TextStyle(
                            letterSpacing: 1.0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              AnimatedPositioned(
                //텍스트 폼 필드
                duration: Duration(milliseconds: 500),
                curve: Curves.easeIn,
                top: 250,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeIn,
                  padding: EdgeInsets.all(20.0),
                  height: isSignupScreen ? 280.0 : 250.0,
                  width: MediaQuery.of(context).size.width - 40,
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 15,
                          spreadRadius: 5),
                    ],
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isSignupScreen = false;
                                });
                              },
                              child: Column(
                                children: [
                                  Text(
                                    'Login',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: !isSignupScreen
                                            ? Palette.activeColor
                                            : Palette.textColor1),
                                  ),
                                  if (!isSignupScreen)
                                    Container(
                                      margin: EdgeInsets.only(top: 3),
                                      height: 2,
                                      width: 55,
                                      color: Colors.orange,
                                    )
                                ],
                              ),
                            ),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isSignupScreen = true;
                                  });
                                },
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Sign up',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: isSignupScreen
                                                  ? Palette.activeColor
                                                  : Palette.textColor1),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        if (isSignupScreen)
                                          GestureDetector(
                                            //이미지 등록 버튼 코드
                                            onTap: () {
                                              showAlert(context);
                                            },
                                            child: Icon(
                                              Icons.image,
                                              color: isSignupScreen
                                                  ? Colors.cyan
                                                  : Colors.grey[300],
                                            ),
                                          )
                                      ],
                                    ),
                                    if (isSignupScreen)
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(0, 3, 35, 0),
                                        height: 2,
                                        width: 55,
                                        color: Colors.orange,
                                      )
                                  ],
                                ))
                          ],
                        ),
                        if (isSignupScreen)
                          Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        key: ValueKey(1),
                                        validator: (value) {
                                          if (value!.isEmpty ||
                                              value!.length < 4) {
                                            return 'Please enter at least 4 characters';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          userName = value!;
                                        },
                                        onChanged: (value) {
                                          userName = value;
                                        },
                                        decoration: InputDecoration(
                                            prefixIcon: Icon(
                                              Icons.account_circle,
                                              color: Palette.iconColor,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Palette.textColor1),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20.0),
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Palette.textColor1),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(30.0),
                                              ),
                                            ),
                                            hintText: 'User name',
                                            hintStyle: TextStyle(
                                                color: Palette.textColor1,
                                                fontSize: 14),
                                            contentPadding: EdgeInsets.all(10)),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      TextFormField(
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        key: ValueKey(2),
                                        validator: (value) {
                                          if (value!.isEmpty ||
                                              !value.contains('@')) {
                                            return 'Please enter a valid email address';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          userEmail = value!;
                                        },
                                        onChanged: (value) {
                                          userEmail = value;
                                        },
                                        decoration: InputDecoration(
                                            prefixIcon: Icon(
                                              Icons.email,
                                              color: Palette.iconColor,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Palette.textColor1),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20.0),
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Palette.textColor1),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(30.0),
                                              ),
                                            ),
                                            hintText: 'email',
                                            hintStyle: TextStyle(
                                                color: Palette.textColor1,
                                                fontSize: 14),
                                            contentPadding: EdgeInsets.all(10)),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      TextFormField(
                                        obscureText: true,
                                        key: ValueKey(3),
                                        validator: (value) {
                                          if (value!.isEmpty ||
                                              value!.length < 6) {
                                            return 'Password must be at least 7 charaters long';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          userPassword = value!;
                                        },
                                        onChanged: (value) {
                                          userPassword = value;
                                        },
                                        decoration: InputDecoration(
                                            prefixIcon: Icon(
                                              Icons.password,
                                              color: Palette.iconColor,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Palette.textColor1),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20.0),
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Palette.textColor1),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(30.0),
                                              ),
                                            ),
                                            hintText: 'password',
                                            hintStyle: TextStyle(
                                                color: Palette.textColor1,
                                                fontSize: 14),
                                            contentPadding: EdgeInsets.all(10)),
                                      )
                                    ],
                                  ))),
                        if (!isSignupScreen)
                          Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        key: ValueKey(4),
                                        validator: (value) {
                                          if (value!.isEmpty ||
                                              !value.contains('@')) {
                                            return 'Please enter a valid email address';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          userEmail = value!;
                                        },
                                        onChanged: (value) {
                                          userEmail = value;
                                        },
                                        decoration: InputDecoration(
                                            prefixIcon: Icon(
                                              Icons.email,
                                              color: Palette.iconColor,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Palette.textColor1),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20.0),
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Palette.textColor1),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(30.0),
                                              ),
                                            ),
                                            hintText: 'email',
                                            hintStyle: TextStyle(
                                                color: Palette.textColor1,
                                                fontSize: 14),
                                            contentPadding: EdgeInsets.all(10)),
                                      ),
                                      SizedBox(
                                        height: 8.0,
                                      ),
                                      TextFormField(
                                        obscureText: true,
                                        key: ValueKey(5),
                                        validator: (value) {
                                          if (value!.isEmpty ||
                                              value!.length < 6) {
                                            return 'Password must be at least 7 charaters long';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          userPassword = value!;
                                        },
                                        onChanged: (value) {
                                          userPassword = value;
                                        },
                                        decoration: InputDecoration(
                                            prefixIcon: Icon(
                                              Icons.password,
                                              color: Palette.iconColor,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Palette.textColor1),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20.0),
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Palette.textColor1),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(30.0),
                                              ),
                                            ),
                                            hintText: 'password',
                                            hintStyle: TextStyle(
                                                color: Palette.textColor1,
                                                fontSize: 14),
                                            contentPadding: EdgeInsets.all(10)),
                                      ),
                                    ],
                                  )))
                      ],
                    ),
                  ),
                ),
              ),
              AnimatedPositioned(
                  //전송버튼
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeIn,
                  top: isSignupScreen ? 480 : 450,
                  right: 0,
                  left: 0,
                  child: Center(
                    child: GestureDetector(
                      onTap: () async {
                        setState(() {
                          showspinner = true;
                        });
                        if (isSignupScreen) {
                          if (userPickedimage == null) {
                            setState(() {
                              showspinner = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Image를 넣어주세요.'),
                                  backgroundColor: Colors.black),
                            );
                            return;
                          }
                          _tryValidation();

                          try {
                            final newUser = await _authentication
                                .createUserWithEmailAndPassword(
                              email: userEmail,
                              password: userPassword,
                            );

                            final refimage = FirebaseStorage.instance
                                .ref()
                                .child('picked_image')
                                .child(newUser.user!.uid +
                                    '.png'); //firebasestorage에 접근하여 클라우드 버킷을 참조하여 접근함 => 어떤 sub폴더에 파일들을 저장할지에 대한 코드
                            //앞 child는 폴더 지정, 뒷 child는 이미지 name지정(유저의 uid로 저장)

                            await refimage.putFile(
                                userPickedimage!); // putFile은 uploadTask를 반환 future와 비슷하다고 생각하면 됨 await사용

                            final url = await refimage.getDownloadURL();

                            await FirebaseFirestore.instance //회원가입 정보 전달 코드
                                .collection('user')
                                .doc(newUser.user!.uid)
                                .set({
                              'username': userName,
                              'email': userEmail,
                              'password': userPassword,
                              'pickedimage': url,
                            });
                            if (newUser.user != null) {
                              /*Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return ChatScreen();
                              }));*/
                              setState(() {
                                showspinner = false;
                              });
                            }
                          } catch (e) {
                            print(e);
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        '올바른 name, email, Password를 입력해주세요.'),
                                    backgroundColor: Colors.black),
                              );
                              setState(() {
                                showspinner = false;
                              });
                            }
                          }
                        }
                        if (!isSignupScreen) {
                          _tryValidation();

                          try {
                            final newUser = await _authentication //로그인 정보 확인
                                .signInWithEmailAndPassword(
                                    email: userEmail, password: userPassword);
                            if (newUser.user != null) {
                              /*Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return ChatScreen();
                              }));*/
                              setState(() {
                                showspinner = false;
                              });
                            }
                          } catch (e) {
                            print(e);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('올바른 email과 Password를 입력해주세요.'),
                                  backgroundColor: Colors.black),
                            );
                            setState(() {
                              showspinner = false;
                            });
                          }
                        }
                      },
                      child: Container(
                          padding: EdgeInsets.all(15),
                          height: 90,
                          width: 90,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50)),
                          child: Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [Colors.orange, Colors.red],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomLeft),
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    spreadRadius: 1,
                                    blurRadius: 1,
                                    offset: Offset(0, 1),
                                  )
                                ]),
                            child: Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            ),
                          )),
                    ),
                  )),
              AnimatedPositioned(
                  //google button
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeIn,
                  top: isSignupScreen
                      ? MediaQuery.of(context).size.height - 125
                      : MediaQuery.of(context).size.height - 165,
                  right: 0,
                  left: 0,
                  child: Column(
                    children: [
                      Text(!isSignupScreen
                          ? 'or Signin with'
                          : 'or Signup with'),
                      SizedBox(
                        height: 15,
                      ),
                      TextButton.icon(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                            primary: Colors.white,
                            minimumSize: Size(155, 40),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            backgroundColor: Palette.googleColor),
                        icon: Icon(Icons.add),
                        label: Text('Google'),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
