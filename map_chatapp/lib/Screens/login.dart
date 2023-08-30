import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class MyLogin extends StatefulWidget {
  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  String email, pswd;
  var signIn;
  bool sspin = false;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    var authc = FirebaseAuth.instance;

    return ModalProgressHUD(
      inAsyncCall: sspin,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: 200,
                  height: 200,
                  child: Image.asset('images/chat1.jpg'),
                ),
                Center(
                  child: Container(
                    height: height * 0.50,
                    width: width * 0.75,
                    color: Colors.white10,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 50,
                        ),
                        Container(
                          child: TextField(
                            onChanged: (val) {
                              email = val;
                            },
                            decoration: InputDecoration(
                              hintText: 'Enter Email',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: TextField(
                            onChanged: (val) {
                              pswd = val;
                            },
                            decoration: InputDecoration(
                              hintText: 'Enter Password',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                            obscureText: true,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Material(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(10),
                          elevation: 10,
                          child: MaterialButton(
                              minWidth: 150,
                              onPressed: () async {
                                try {
                                  setState(() {
                                    sspin = true;
                                  });
                                  signIn =
                                      await authc.signInWithEmailAndPassword(
                                          email: email, password: pswd);
                                  print(signIn);
                                } catch (e) {
                                  print(e);
                                }
                                if (signIn != null) {
                                  Navigator.pushNamed(context, 'chat');
                                  setState(() {
                                    sspin = false;
                                  });
                                } else {
                                  setState(() {
                                    sspin = false;
                                  });

                                  print('invalid input');
                                }
                              },
                              child: Text('Login')),
                        ),
                      ],
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'reg');
                  },
                  child: Text(
                    "Don't have an account? Register here",
                    style: TextStyle(fontSize: 15),
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
