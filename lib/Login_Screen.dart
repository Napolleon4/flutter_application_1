import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'Forget_password.dart';
import 'Services/Auth.dart';
import 'Signup.dart';
import 'main.dart';

class Login_Scree extends StatefulWidget {
  const Login_Scree({Key? key}) : super(key: key);

  @override
  State<Login_Scree> createState() => _Login_ScreeState();
}

class _Login_ScreeState extends State<Login_Scree> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Auth _authservice = Auth();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Image.asset(
                      "images/arabaAcma.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                ],
              ),
              Positioned(
                left: 20,
                top: 40,
                child: Container(
                    child: IconButton(
                        color: Colors.white,
                        onPressed: () {
                          Get.to(MyHomePage(),
                              transition: Transition.cupertino,
                              duration: Duration(seconds: 1));
                        },
                        icon: Icon(Icons.arrow_back_ios))),
              ),
              Positioned(
                left: 30,
                top: 100,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Hoşgeldin!',
                    style: GoogleFonts.montserrat(
                        fontSize: 25, color: Colors.white),
                  ),
                ),
              )
            ]),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 40),
              child: TextFormField(
                controller: _email,
                validator: (value) {
                  if (!value!.contains("@") || value == null || value.isEmpty) {
                    return 'Lütfen İYTE E-mail adresinizi giriniz';
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: FaIcon(
                      Icons.email,
                      color: Color(0xFF3DA5D9),
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  labelText: 'E-mail',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 40),
              child: TextFormField(
                controller: _password,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen Soy İsminizi Girinz';
                  }
                  return null;
                },
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: FaIcon(
                      Icons.lock,
                      color: Color(0xFF3DA5D9),
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  labelText: 'Şifre',
                ),
              ),
            ),
            TextButton(
                onPressed: (() {
                  Get.to(
                    () => Forget_password(),
                    transition: Transition.cupertino,
                    duration: Duration(seconds: 1),
                  );
                }),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 175,
                    ),
                    Icon(
                      Icons.lock,
                      size: 17,
                      color: Color(0xFF3DA5D9),
                    ),
                    Text(
                      "Şifremi Unuttum",
                      style: GoogleFonts.montserrat(
                          color: Color(0xFF3DA5D9), fontSize: 17),
                    )
                  ],
                )),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Future(() async {
                    await _authservice.signIn(_email.text.toString().trim(),
                        _password.text.toString().trim());
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(40, 40),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
              ),
              child: Text(
                  "                      Giriş Yap                      ",
                  style: GoogleFonts.montserrat(
                      color: Colors.white, fontSize: 20)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Divider(
                    indent: 43.0,
                    endIndent: 10.0,
                    thickness: 1,
                  ),
                ),
                Text(
                  "yada",
                  style: GoogleFonts.montserrat(color: Color(0xFF3DA5D9)),
                ),
                Expanded(
                  child: Divider(
                    indent: 10.0,
                    endIndent: 43.0,
                    thickness: 1,
                  ),
                ),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(40, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    10.0,
                  ),
                ),
                primary: Colors.white,
                side: BorderSide(
                  color: Colors.grey,
                ),
              ),
              onPressed: (() => {
                    Get.to(
                      () => Signup(),
                      transition: Transition.cupertino,
                      duration: Duration(seconds: 1),
                    ),
                  }),
              child: Text(
                  "                       Kayıt Ol                       ",
                  style: GoogleFonts.montserrat(
                      color: Color(0xFF3DA5D9), fontSize: 20)),
            ),
          ],
        ),
      ),
    ));
  }
}
