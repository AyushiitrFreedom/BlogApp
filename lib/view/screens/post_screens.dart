import 'dart:io';

import 'package:bookrentingapp/utils/utils.dart';
import 'package:bookrentingapp/view/screens/show_complete_post.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nice_buttons/nice_buttons.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage ;

class PostScreen extends StatefulWidget {
  
  PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  File? _image;
  final picker = ImagePicker();

  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

  Future<void> getGalleryImage() async{
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile!= null) {
      _image = File(pickedFile.path);
    }else{
      print('no image picked');
    }
    });
    
  }
  bool loading = false;
  final _titlecontroller = TextEditingController();
  final _contentcontroller = TextEditingController();
  final databaseRef = FirebaseDatabase.instance.ref('Post');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  loading ? Center(child: CircularProgressIndicator()) : SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 90,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Write  a  Blog",
                  style: GoogleFonts.notoSansAdlamUnjoined(
                      textStyle: TextStyle(
                          fontSize: 30,
                          letterSpacing: 5,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            SizedBox(
              height: 140,
            ),
            SizedBox(
                width: 300.0,
                child: TextFormField(
                  controller: _titlecontroller,
                  maxLines: null,
                    decoration: InputDecoration(
                  // prefixIcon: Icon(Icons.title),
                  hintText: 'T I T L E',
                ))),
            SizedBox(
              height: 70,
            ),
            NiceButtons(
              borderRadius: 30,
                startColor: Colors.black,
                endColor: Colors.black,
                width: 320,
                stretch: false,
                borderColor: Colors.black,
                gradientOrientation: GradientOrientation.Horizontal,
                onTap: (finish) {
                  getGalleryImage();
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 80,
                    ),
                    Icon(Icons.cloud_upload, size: 29 , color: Colors.white,),
                    SizedBox(
                      width: 30,
                    ),
                    Expanded(
                      child: Text("I M A G E" , style: TextStyle(  color: Colors.white , fontSize: 25),),
                    ),
                  ],
                )),
      
                SizedBox(
                  height: 70,
                ),
                SizedBox(
                width: 300.0,
                child: TextFormField(
                  controller: _contentcontroller,
                  maxLines: null,
                    decoration: InputDecoration(
                  // prefixIcon: Icon(Icons.title),
                  hintText: 'C O N T E N T',
                ))),
      
                SizedBox(
                  height: 90,
                ),
      
                NiceButtons(
                  borderRadius: 30,
                startColor: Colors.blue,
                endColor: Colors.blue,
                width: 200,
                stretch: false,
                borderColor: Colors.blue,
                gradientOrientation: GradientOrientation.Horizontal,
                onTap: (finish) async{
                  loading = true;
                  var id = DateTime.now().millisecondsSinceEpoch.toString();
                  firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref('/images'+id);
                  firebase_storage.UploadTask uploadTask = ref.putFile(_image!.absolute);
                  await Future.value(uploadTask);
                  var newurl =  await ref.getDownloadURL();
                  
                  databaseRef.child(id).set({
                    'id' : id,
                    'title':_titlecontroller.text.toString(),
                    'content':_contentcontroller.text.toString(),
                    'image': newurl,  
                  }).then( (value) {
                    Utils().ToastMessage('Post added');
                    setState(() {
                      loading = false;
                    });
                    Navigator.push(context, MaterialPageRoute(builder: ((context) => ShowCompletePost(id: id))));
                  }).onError((error, stackTrace) {
                     Utils().ToastMessage(error.toString());
                    setState(() {
                      loading = false;
                    });
                  });
                },
                child: Center(child: Text("P o s t" , style: TextStyle(  color: Colors.white , fontSize: 25),))),
      
      
      
      
          ],
        ),
      ),
    );
  }
}
