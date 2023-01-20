import 'dart:ffi';
import 'dart:ui';

import 'package:bookrentingapp/view/screens/show_complete_post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:characters/characters.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';

class ShowBlog extends StatelessWidget {
  ShowBlog({super.key});
  final auth = FirebaseAuth.instance;
  bool loading = false;

  final ref = FirebaseDatabase.instance.ref('Post');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading ? Center(child: CircularProgressIndicator(),) : SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height ,
              child: Expanded(
                  child: StreamBuilder(
                stream: ref.onValue,
                builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                  if (!snapshot.hasData) {
                    loading = true;
                    return SizedBox();
                  } else {
                    loading = false;
                    Map<dynamic, dynamic> map =
                        snapshot.data!.snapshot.value as dynamic;

                    List<dynamic> list = [];

                    list.clear();

                    list = map.values.toList();

                    return ListView.builder(
                        physics: ScrollPhysics(),
                        shrinkWrap: false,

                        itemCount: snapshot.data!.snapshot.children.length ,
          
                        itemBuilder: (context, index) {
                          
                         
                          return Column(
                            children: [
                             
                              InkWell(
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: ((context) => ShowCompletePost(id: list[index]['id'])))),
                                child: ListTile(
                                  title: Text(
                                    list[index]['title'],
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                      ),
                                    ),
                                  ),
                                  subtitle: Text(list[index]['content'].toString().characters.take(100).toString(), style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      fontSize: 15
                                    ),
                                  ),),
                                  leading: Image(
                                    image: NetworkImage(
                                        list[index]['image']),
                                  ),
                              
                                ),
                              ),
                               SizedBox(
                                height: 40,
                              ),
                
                            ],
                          );
                        });
                  }
                },
              )),
            ),
           
           
            
          ],
        ),
      ),
    );
  }
}
