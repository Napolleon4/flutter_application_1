import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_1/Services/Status_Service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'Login_Screen.dart';
import 'Main_Screen.dart';
import 'Services/Auth.dart';

class Profile_Settings extends StatefulWidget {
  String email;
  Profile_Settings({Key? key, required this.email}) : super(key: key);

  @override
  State<Profile_Settings> createState() => _Profile_SettingsState();
}

class _Profile_SettingsState extends State<Profile_Settings> {
  @override
  final currentuser = FirebaseAuth.instance;
  Auth _authservice = Auth();
  Status_Service _status_service = Status_Service();

  late File _image;
  final ImagePicker _picker = ImagePicker();
  String _Person_PP = "Not Attend";
  String imageUrl = "not attend";
  StreamController _myStream = StreamController.broadcast();

  TextEditingController newName = TextEditingController();
  TextEditingController newSurname = TextEditingController();

  Future uploadToStoarge(File _imageFile) async {
    String path = widget.email + "-Photo";
    TaskSnapshot uploadTask = await FirebaseStorage.instance
        .ref()
        .child("Photos")
        .child(path)
        .putFile(_imageFile);
    imageUrl = await uploadTask.ref.getDownloadURL();
    return imageUrl;
  }

  void getImage() async {
    final _pickedFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 40);
    setState(() {
      if (_pickedFile != null) {
        _image = File(_pickedFile.path);
      } else {
        return null;
      }
    });

    if (_pickedFile != null) {
      _Person_PP = await uploadToStoarge(_image);
    }
    Get.snackbar("Profil Fotoğrafınız Güncellendi", "Lütfen bekleyiniz...",
        backgroundColor: Colors.white,
        snackPosition: SnackPosition.TOP,
        colorText: Colors.blue,
        duration: Duration(seconds: 3));
    _status_service.updatePhoto(_Person_PP).then((value) => print(_Person_PP));
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(
              FontAwesomeIcons.arrowLeft,
              color: Colors.blue,
              size: 20,
            ),
            onPressed: () {
              Get.to(() => Main_Screen());
            },
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Users")
                .where("uid", isEqualTo: currentuser.currentUser!.uid)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> asyncSnapshot) {
              if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (asyncSnapshot.hasData) {
                return SizedBox(
                  height: 1000,
                  width: 1000,
                  child: ListView.builder(
                      itemCount: 1,
                      itemBuilder: ((context, index) {
                        DocumentSnapshot mypost =
                            asyncSnapshot.data!.docs[index];
                        return SizedBox(
                          height: 800,
                          width: 800,
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 40.0),
                                child: InkWell(
                                  onTap: () {
                                    getImage();
                                  },
                                  child: CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(mypost["Profile_Photo"]),
                                      backgroundColor: Colors.blue,
                                      radius: 75),
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              ListTile(
                                title: Text(
                                  mypost["Name"],
                                  style: GoogleFonts.montserrat(
                                    fontSize: 20,
                                  ),
                                ),
                                textColor: Color(0xFF3DA5D9),
                                iconColor: Color(0xFF3DA5D9),
                                leading: Icon(Icons.people),
                                trailing: IconButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (builder) {
                                            return AlertDialog(
                                              title: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Yeni İsim Giriniz",
                                                    style:
                                                        GoogleFonts.montserrat(
                                                            color: Colors.blue),
                                                  ),
                                                ],
                                              ),
                                              content: TextFormField(
                                                controller: newName,
                                              ),
                                              actions: [
                                                TextButton(
                                                    onPressed: () async {
                                                      await _status_service
                                                          .updatename(newName
                                                              .text
                                                              .toString()
                                                              .trim());
                                                      print(newName.text
                                                          .toString()
                                                          .trim());
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text(
                                                      "Güncelle",
                                                      style: GoogleFonts
                                                          .montserrat(
                                                              color:
                                                                  Colors.blue),
                                                    ))
                                              ],
                                            );
                                          });
                                    },
                                    icon: Icon(Icons.settings)),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              ListTile(
                                title: Text(
                                  mypost["Surname"],
                                  style: GoogleFonts.montserrat(
                                    fontSize: 20,
                                  ),
                                ),
                                textColor: Color(0xFF3DA5D9),
                                iconColor: Color(0xFF3DA5D9),
                                leading: Icon(Icons.people),
                                trailing: IconButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (builder) {
                                            return AlertDialog(
                                              title: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Yeni Soyisim Giriniz",
                                                    style:
                                                        GoogleFonts.montserrat(
                                                            color: Colors.blue),
                                                  ),
                                                ],
                                              ),
                                              content: TextFormField(
                                                controller: newSurname,
                                              ),
                                              actions: [
                                                TextButton(
                                                    onPressed: () async {
                                                      await _status_service
                                                          .updateSurname(
                                                              newSurname.text
                                                                  .toString()
                                                                  .trim());
                                                      print(newSurname.text
                                                          .toString()
                                                          .trim());
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text(
                                                      "Güncelle",
                                                      style: GoogleFonts
                                                          .montserrat(
                                                              color:
                                                                  Colors.blue),
                                                    ))
                                              ],
                                            );
                                          });
                                    },
                                    icon: Icon(Icons.settings)),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              ListTile(
                                title: Text(
                                  mypost["email"],
                                  style: GoogleFonts.montserrat(
                                    fontSize: 17,
                                  ),
                                ),
                                textColor: Color(0xFF3DA5D9),
                                iconColor: Color(0xFF3DA5D9),
                                leading: Icon(
                                  Icons.email,
                                ),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Future(() async {
                                      await _authservice
                                          .resetPassword(mypost["email"])
                                          .then((value) => Get.snackbar(
                                              "Lütfen E-postanızı kontrol ediniz",
                                              "",
                                              backgroundColor: Colors.white,
                                              snackPosition: SnackPosition.TOP,
                                              colorText: Colors.blue));
                                    });
                                  },
                                  child: Text(
                                    "Şifre Değiştir",
                                    style: GoogleFonts.montserrat(),
                                  ))
                            ],
                          ),
                        );
                      })),
                );
              } else if (asyncSnapshot.hasError) {
                return CircularProgressIndicator();
              } else {
                return CircularProgressIndicator();
              }
            }),
      ),
    );
  }
}