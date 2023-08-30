import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:map_chatapp/Screens/chat.dart';
import 'package:map_chatapp/Screens/login.dart';
import 'package:map_chatapp/Screens/registration.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: 'login',
    routes: {
      'chat': (context) => MyChat(),
      'reg': (context) => MyReg(),
      'login': (context) => MyLogin(),
    },
  ));
}
