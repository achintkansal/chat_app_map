import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class MyReg extends StatefulWidget {
  @override
  _MyRegState createState() => _MyRegState();
}

class _MyRegState extends State<MyReg> {
  String email, pswd;
  bool sspin = false;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    var user;
    var authc = FirebaseAuth.instance;
    return ModalProgressHUD(
      inAsyncCall: sspin,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Registration'),
          backgroundColor: Colors.pink,
        ),
        body: Center(
          child: Container(
            height: height * 0.50,
            width: width * 0.75,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  onChanged: (val) {
                    email = val;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter new username',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  onChanged: (val) {
                    pswd = val;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter new password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  obscureText: true,
                ),
                SizedBox(
                  height: 10,
                ),
                Material(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(10),
                  elevation: 10,
                  child: MaterialButton(
                      minWidth: 200,
                      height: 40,
                      onPressed: () async {
                        try {
                          setState(() {
                            sspin = true;
                          });
                          user = await authc.createUserWithEmailAndPassword(
                              email: email, password: pswd);
                          print(user);
                        } catch (e) {
                          print(e);
                        }
                        if (user != null) {
                          Navigator.pushNamed(context, 'chat');
                          setState(() {
                            sspin = false;
                          });
                        }
                      },
                      child: Text('Register')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
