import 'dart:async';

import 'package:bookrentingapp/utils/utils.dart';
import 'package:bookrentingapp/view/screens/auth/login_screen.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';
class Profile extends StatefulWidget {
  Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String title = '';

  String content = '';
  String image = '';
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('User');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 70,
            ),
            Container(
              // padding: EdgeInsets.only(left: 20),
              child: Text(
                "My Profile",
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(86, 103, 133, 1),
                        fontSize: 40)),
              ),
            ),
            SizedBox(
              height: 90,
            ),
            Container(
              // margin: EdgeInsets.only(left: 130),
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(image),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              // padding: EdgeInsets.only(left: 130),
              child: Text(
                title,
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(86, 103, 133, 1),
                        fontSize: 20)),
              ),
            ),
            SizedBox(
              height: 90,
            ),
            Container(
              // padding: EdgeInsets.only(left: 80),
              child: Text(
                "About ME",
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(86, 103, 133, 1),
                        fontSize: 20)),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
        
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                content,
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 179, 184, 196),
                        fontSize: 15)),
              ),
      
            ),
            SizedBox(
              height: 90,
            ),
            InkWell(
              onTap: () {
                print(auth.currentUser!.email.toString());
                auth.signOut().then((value){
                  
                  Navigator.push(context, MaterialPageRoute(builder: ((context) => LoginScreen())));
                }).onError((error, stackTrace) {
                  Utils().ToastMessage(error.toString());
                });
              },
              child: Text("Logout?" , style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                )
              ),),
            ),
            SizedBox(
                height: MediaQuery.of(context).size.height,
                child: FirebaseAnimatedList(
                    query: ref,
                    itemBuilder: ((context, snapshot, animation, index) {
                      if (snapshot.child('email').value.toString() == auth.currentUser!.email.toString()) {
                        Timer(Duration(seconds: 0), (() {
                          setState(() {
                            title = snapshot.child('name').value.toString();
                            content = snapshot.child('bio').value.toString();
                            image = snapshot.child('image').value.toString();
                          });
                          
                        }));
      
                        return ListTile();
                      } else {
                        return ListTile(
                          dense: true,
                          title: Text(""),
                        );
                      }
                    })),
              ),
          ],
        ),
      ),
    );
  }
}
