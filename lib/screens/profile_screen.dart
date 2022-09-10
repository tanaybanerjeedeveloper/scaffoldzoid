import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  //ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image;
  final picker = ImagePicker();

  final _formKey = GlobalKey<FormState>();
  TextEditingController _aboutController = TextEditingController();
  TextEditingController _orangeTypeController = TextEditingController();
  TextEditingController _rateController = TextEditingController();

  Future getImageGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('no image selected');
      }
    });
  }

  Future getImageCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('no image selected');
      }
    });
  }

  void dialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: Container(
              height: 120,
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      getImageCamera();
                      Navigator.pop(context);
                    },
                    child: ListTile(
                      leading: Icon(Icons.camera),
                      title: Text('Camera'),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      getImageGallery();
                      Navigator.pop(context);
                    },
                    child: ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Gallery'),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(17.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    dialog(context);
                  },
                  child: Container(
                    height: mediaQuery.height * 0.2,
                    width: double.infinity,
                    color: Colors.grey,
                    child: _image != null
                        ? ClipRect(
                            child: Image.file(
                              _image!.absolute,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              //color: Colors.grey,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            width: 300,
                            height: 100,
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.blue,
                            ),
                          ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(user.email!),
                SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        minLines: 1,
                        maxLines: 5,
                        controller: _aboutController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter your description'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _orangeTypeController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter your orange type'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _rateController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter your rate/kg'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.orange,
                            padding: EdgeInsets.symmetric(vertical: 15),
                          ),
                          onPressed: () {
                            createUser(
                                about: _aboutController.text,
                                orangeType: _orangeTypeController.text,
                                rate: _rateController.text,
                                email: user.email!);
                          },
                          child: Text('Submit'),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15)),
                    onPressed: () => FirebaseAuth.instance.signOut(),
                    child: Text('Log Out'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future createUser(
      {required about,
      required orangeType,
      required rate,
      required email}) async {
    final docUser = FirebaseFirestore.instance.collection('sellers').doc();
    final json = {
      'about': about,
      'orange': orangeType,
      'rate': rate,
      'email': email,
    };
    await docUser.set(json);
  }
}
