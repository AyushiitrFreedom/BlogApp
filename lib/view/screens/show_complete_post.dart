import 'dart:async';

import 'package:bookrentingapp/view/screens/home.dart';
import 'package:bookrentingapp/view/screens/showblog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

class ShowCompletePost extends StatefulWidget {
  String id;

  ShowCompletePost({super.key, required this.id});

  @override
  State<ShowCompletePost> createState() => _ShowCompletePostState();
}

class _ShowCompletePostState extends State<ShowCompletePost> {
  String title = '';

  String content = '';
  String image = '';

  final auth = FirebaseAuth.instance;

  final ref = FirebaseDatabase.instance.ref('Post');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
            ),

            InkWell(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: ((context) => Home()))),
              child: Container(
                padding: EdgeInsets.only(left: 10),
                child: Icon(Icons.home, color: Colors.pink, size: 30,),
              ),
            ),
            
            Container(
              padding: EdgeInsets.fromLTRB(50, 20, 40, 40),
              child: Text(title,
                  style: GoogleFonts.robotoMono(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 30,
                          height: 2))),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Image(image: NetworkImage(image)  ), //this error needs to get solved 
            ),
            Container(
              padding: EdgeInsets.all(40),
              child: Text(content,
                  style: GoogleFonts.robotoMono(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          height: 1.9,
                          color: Colors.grey))),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: FirebaseAnimatedList(
                  query: ref,
                  itemBuilder: ((context, snapshot, animation, index) {
                    if (snapshot.child('id').value.toString() == widget.id) {
                      Timer(Duration(seconds: 0), (() {
                        setState(() {
                          title = snapshot.child('title').value.toString();
                          content = snapshot.child('content').value.toString();
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
