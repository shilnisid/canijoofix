// ignore_for_file: inference_failure_on_function_invocation, unused_local_variable

import '../../..//routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  Stream<User?> get streamAuthStatus => auth.authStateChanges();

  //get isPasswordVisible => null;

  //get handleShowPassword => null;

  var isPasswordVisible = false.obs;

  handleShowPassword() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void signInWithGoogle() async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: [
          'email',
          'https://www.googleapis.com/auth/userinfo.profile',
        ],
      );
      GoogleSignInAccount? myAcc = await googleSignIn.signIn();
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      if (myAcc != null) {
        final GoogleSignInAuthentication googleAuth =
            await myAcc.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);
        prefs.setString('google', auth.currentUser!.uid);
        return Get.offAndToNamed(Routes.NAVBAR);
      } else {
        throw " Belum memilih akun";
      }
    } catch (e) {
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: "coba lagi",
      );
    }
  }

  // Obtain the auth details from the request

  // Create a new credential

  // Once signed in, return the UserCredential

  void login() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if(emailC.text.isEmpty && passC.text.isEmpty){
      Get.snackbar('Error', "Field can't empty!",
          backgroundColor: Colors.lightGreen[400]);

      return;
    }
    try {
      await auth.signInWithEmailAndPassword(
        email: emailC.text,
        password: passC.text,
      );
      prefs.setString('email', emailC.text);
      Get.offAndToNamed(Routes.NAVBAR);

    } catch (e) {
      Get.snackbar('Account not  found', "Please sign up",
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.lightGreen[400]);
      //print(e);
    }

  }

  //var loggedin = true;

  // void loadData() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   if (prefs.getString('email') != null && prefs.getString('google') != null) {

  //     return Get.offAndToNamed(Routes.NAVBAR);
  //   } else {

  //     return Get.offAndToNamed(Routes.LOGIN);
  //   }
  //   //prefs.getString(GoogleAuthProvider.GOOGLE_SIGN_IN_METHOD);
  // }

  //  @override
  // void onInit() {
  //   loadData();
  //   super.onInit();
  // }

  // void onDispose() {
  //   emailC.dispose();
  //   passC.dispose();
  // }
}
