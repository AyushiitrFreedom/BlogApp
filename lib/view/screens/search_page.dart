import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'dart:ui';

import 'package:bookrentingapp/view/screens/show_complete_post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:characters/characters.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchPage extends StatefulWidget {
  SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final auth = FirebaseAuth.instance;
  bool loading = false;
  final search = TextEditingController();

  final ref = FirebaseDatabase.instance.ref('Post');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading ? Center(child: CircularProgressIndicator()) : SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 80,
            ),
            // Note: Same code is applied for the TextFormField as well
            Container(
              width: 300,
              height: 50,
              child: TextFormField(
                controller: search,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "Search",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 3,
                        color: Color.fromARGB(255, 27, 26, 27)), //<-- SEE HERE
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height,
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
                    shrinkWrap: true,
                    itemCount: snapshot.data!.snapshot.children.length,
                    itemBuilder: (context, index) {
                      final title = list[index]['title'];
                      if (search.text.isEmpty) {
                        return Column(
                          children: [
                            InkWell(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          ShowCompletePost(
                                              id: list[index]['id'])))),
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
                                subtitle: Text(
                                  list[index]['content']
                                      .toString()
                                      .characters
                                      .take(100)
                                      .toString(),
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(fontSize: 15),
                                  ),
                                ),
                                leading: Image(
                                  image: NetworkImage(list[index]['image']),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                          ],
                        );
                      } else if (title.toString().toLowerCase().contains(
                          search.text.toLowerCase().toLowerCase())) {
                        return Column(
                          children: [
                            InkWell(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          ShowCompletePost(
                                              id: list[index]['id'])))),
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
                                subtitle: Text(
                                  list[index]['content']
                                      .toString()
                                      .characters
                                      .take(100)
                                      .toString(),
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(fontSize: 15),
                                  ),
                                ),
                                leading: Image(
                                  image: NetworkImage(list[index]['image']),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                          ],
                        );
                      } else {
                        return Container();
                      }
                    });
              }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
