import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../Last_step.dart';
import '../Main_Screen.dart';

class Auth {
  final _firebaseauth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  Future signIn(String email, String password) async {
    try {
      await _firebaseauth.signInWithEmailAndPassword(
          email: email, password: password);
      if (FirebaseAuth.instance.currentUser?.emailVerified == false) {
        Get.snackbar(
            "Your E-mail has not been confirmed", "Please Verify Your E-Mail",
            backgroundColor: Colors.white,
            snackPosition: SnackPosition.TOP,
            colorText: Colors.blue);
      } else {
        Get.to(() => Main_Screen());
      }
    } on FirebaseAuthException catch (e) {
      String? title = e.code.replaceAll(RegExp('-'), ' ').capitalize;

      String message = '';

      if (e.code == 'wrong-password') {
        message = 'Invalid Password. Please try again!';
      } else if (e.code == 'user-not-found') {
        message =
            ('The account does not exists for $email. Create your account by signing up.');
      } else {
        message = e.message.toString();
      }

      Get.snackbar(title!, message,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.white,
          colorText: Colors.blue);
    } catch (e) {
      Get.snackbar(
        'Error occured!',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white,
        colorText: Colors.blue,
      );
    }
  }

  Future Out() async {
    return await FirebaseAuth.instance.signOut();
  }

  Future signUp(String email, String password) async {
    try {
      await _firebaseauth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        Get.snackbar("Heasbınız Oluşturuldu", "Lütfen bekleyiniz...",
            backgroundColor: Colors.white,
            snackPosition: SnackPosition.TOP,
            colorText: Colors.blue);
      }).then((value) => Get.to(() => Last_step(),
              transition: Transition.cupertino,
              duration: Duration(seconds: 1)));
    } on FirebaseAuthException catch (e) {
      String? title = e.code.replaceAll(RegExp('-'), ' ').capitalize;
      String message = '';

      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = ('The account already exists for that email.');
      } else {
        message = e.message.toString();
      }

      Get.snackbar(title!, message,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.blue,
          colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error occured!', e.toString(),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.blue,
          colorText: Colors.white);
    }
  }

  Future<String> getCurrentId() async {
    String uid = await _firebaseauth.currentUser!.uid;
    return uid;
  }

  Future<void> resetPassword(String email) async {
    await _firebaseauth.sendPasswordResetEmail(email: email);
  }

  Future sendEmailVerif() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (!(user!.emailVerified)) {
      await user.sendEmailVerification();
    }
  }
}