import 'dart:async';
import 'package:bookrentingapp/view/screens/home.dart';
import 'package:bookrentingapp/view/screens/show_complete_post.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:bookrentingapp/view/screens/auth/login_screen.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';

import '../view/screens/post_screens.dart';

class SplashServices {
  void isLogin(BuildContext context) async {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('Post/1674042845256').get();
    
    if (user != null) {
      Timer(
          Duration(seconds: 3),
          (() => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Home()),
                      )));
    } else {
      Timer(
          Duration(seconds: 3),
          (() => Navigator.push(context,
              MaterialPageRoute(builder: (context) => LoginScreen()))));
    }
  }
}
