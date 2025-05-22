import '../../../routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';


class SignUpController extends GetxController {
  //TODO: Implement LoginController

  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();
  TextEditingController passC2 = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void checkEmailExists() async {
    List<String> signInMethods = (await auth.signInWithEmailAndPassword(email: emailC.text, password: passC.text)) as List<String>;
    if(signInMethods.isNotEmpty){
      Get.snackbar('Email sudah terdaftar', 'silakan login');
    }else{
      signup();
    }
    return Get.offAllNamed(Routes.LOGIN);
  }


  signup() async {
    try {
      await auth.createUserWithEmailAndPassword(
            email: emailC.text,
            password: passC.text,
          ).then((value) => Get.snackbar('Welcome', 'Account created')).then((value) => Get.offAndToNamed(Routes.LOGIN));
      final firestore = FirebaseFirestore.instance;
      firestore.collection('user').doc(auth.currentUser!.uid).set(
        {'email': emailC.text, 'password': passC.text}).then((value) => Get.offAndToNamed(Routes.LOGIN));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return Get.snackbar('Warning!', 'The password provided is too weak');
      } else if (passC2 != passC) {
        return Get.snackbar('Password', "password didn't match");
      }
    } catch (e) {
      print(e);
    }
  }

  //TextEditingController passC2 = TextEditingController();
  RxBool isPasswordVisible = false.obs;
  void handleShowPassword() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  @override
  void onClose() {
    emailC.dispose();
    passC.dispose();
    passC2.dispose();
    super.onClose();
  }
}
