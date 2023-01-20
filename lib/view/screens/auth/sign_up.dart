import 'dart:ffi';
import 'dart:io';

import 'package:bookrentingapp/utils/utils.dart';
import 'package:bookrentingapp/view/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SignUp extends StatefulWidget {
  SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // imagepicker
  File? _image;
  final picker = ImagePicker();

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> getGalleryImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() async {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        firebase_storage.Reference ref = firebase_storage
                          .FirebaseStorage.instance
                          .ref('/userimages' + id);
                      firebase_storage.UploadTask uploadTask =
                          ref.putFile(_image!.absolute);
                      await Future.value(uploadTask);
                      newurl = await ref.getDownloadURL();
                      setState(() {
                        
                      });
        
      } else {
        print('no image picked');
      }
      
    });
  }

  bool loading = false;
  String? newurl;
  var id = DateTime.now().millisecondsSinceEpoch.toString();
  String profileimg = "https://i.pinimg.com/736x/8b/16/7a/8b167af653c2399dd93b952a48740620.jpg";
  final _formKey = GlobalKey<FormState>();
  final _emailcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();
  final _namecontroller = TextEditingController();
  final _biocontroller = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  final databaseRef = FirebaseDatabase.instance.ref('User');

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    _namecontroller.dispose();
    _biocontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadius.circular(30),
                    image: DecorationImage(
                        image: AssetImage("images/signup.png"),
                        fit: BoxFit.cover),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 130,
                      ),
                      InkWell(
                        onTap: () {
                          
                          getGalleryImage();
                          
                        },
                        child: CircleAvatar(
                          radius: 80,
                          backgroundImage: NetworkImage( newurl ?? profileimg),
                          backgroundColor: Color.fromARGB(255, 239, 237, 237),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 70.0,
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
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email),
                              hintText: 'Email',
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          width: 300.0,
                          child: TextFormField(
                            controller: _passwordcontroller,
                            validator: (value) => value!.length < 6
                                ? "password length should be more than 6"
                                : null,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock),
                              hintText: 'Password',
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          width: 300.0,
                          child: TextFormField(
                            controller: _namecontroller,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              hintText: 'Name',
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          width: 300.0,
                          child: TextFormField(
                            maxLines: null,
                            controller: _biocontroller,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.account_box),
                              hintText: 'Bio',
                            ),
                          ),
                        ),
                      ],
                    )),
                SizedBox(
                  height: 70.0,
                ),
                new GestureDetector(
                  onTap: (() async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        loading = true;
                      });

                      

                      _auth
                          .createUserWithEmailAndPassword(
                              email: _emailcontroller.text.toString(),
                              password: _passwordcontroller.text.toString())
                          .then((value) {
                        setState(() {
                          loading = false;
                        });
                        
                        databaseRef.child(id).set({
                          'id': id,
                          'email':_emailcontroller.text.toString(),
                          'name': _namecontroller.text.toString(),
                          'bio': _biocontroller.text.toString(),
                          'image': newurl,
                        }).then((value) {
                          print("done");
                        }).onError((error, stackTrace) {
                          Utils().ToastMessage(error.toString());
                        });
                        Navigator.push(context,
                            MaterialPageRoute(builder: ((context) => Home())));
                      }).onError((error, stackTrace) {
                        setState(() {
                          loading = false;
                        });
                        Utils().ToastMessage(error.toString());
                      });
                    }
                  }),
                  child: Container(
                    height: 70,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      image: DecorationImage(
                          image: AssetImage("images/signup.png"),
                          fit: BoxFit.cover),
                    ),
                    child: Center(
                      child: Text(
                        "Sign up",
                        style: TextStyle(fontSize: 35, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
