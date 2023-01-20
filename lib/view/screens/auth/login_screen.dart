import 'dart:ui';

import 'package:bookrentingapp/view/screens/post_screens.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../../../utils/utils.dart';
import '../home.dart';
import 'sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final _emailcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();

  FirebaseAuth  _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading ? Center(child: CircularProgressIndicator()) : Column(
        children: [
          Image.asset("images/loginimg.png"),
          Text(
            "Hello",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50.0),
          ),
          SizedBox(
            height: 7.0,
          ),
          Text(
            "Sign into your account",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 163, 162, 162),
              fontSize: 20.0,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(
            height: 40.0,
          ),
          Form(
            key: _formKey,
              child: Column(
            children: [
              SizedBox(
                width: 300.0,
                child: TextFormField(
                  controller: _emailcontroller,
                  validator: (value) =>
                      value!.isEmpty ? "enter an email" : null,
                  onChanged: (value) {
                    ;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    hintText: 'Email',
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 300.0,
                child: TextFormField(
                  controller: _passwordcontroller,
                  validator: (value) => value!.length < 6
                      ? "password length should be more than 6"
                      : null,
                  onChanged: (value) {},
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintText: 'Password',
                  ),
                ),
              ),
            ],
          )),
          SizedBox(
            height: 40.0,
          ),
          new GestureDetector(
            onTap: () {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  loading = true;
                });
                _auth
                    .signInWithEmailAndPassword(
                        email: _emailcontroller.text.toString(),
                        password: _passwordcontroller.text.toString())
                    .then((value) {
                  setState(() {
                    loading = false;
                  });
                  Navigator.push(context, MaterialPageRoute(builder: ((context) => Home())));
                }).onError((error, stackTrace) {
                  setState(() {
                    loading = false;
                  });
                  Utils().ToastMessage(error.toString());
                });
              }
            },
            child: Container(
              height: 70,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                image: DecorationImage(
                    image: AssetImage("images/signup.png"), fit: BoxFit.cover),
              ),
              child: Center(
                child: Text(
                  "log in",
                  style: TextStyle(fontSize: 35, color: Colors.white),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "don't have a account? ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  // fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 163, 162, 162),
                  fontSize: 15.0,
                  letterSpacing: 1.5,
                ),
              ),
              new GestureDetector(
                onTap: () => {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) => SignUp())))
                },
                child: Text(
                  "Create",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              )
            ],
          ),
          
        ],
      ),
    );
  }
}
