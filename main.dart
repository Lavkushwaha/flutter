import 'package:flutter/material.dart';
import 'login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'splash.dart';
import 'mainscreen.dart';

import 'dart:async';

void main() {
  runApp(MyHome());
}



class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {



  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        debugShowCheckedModeBanner: false,
        home: _handleCurrentScreen()
    );
  }
}


Widget _handleCurrentScreen() {
  return new StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {

           return Splash();
        } else {
          if (snapshot.hasData) {
            return new MainScreen();
          }
           return Login();
        }
      }
  );
}

