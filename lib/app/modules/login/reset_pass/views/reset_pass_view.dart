import '../../../../routes/app_pages.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../login/reset_pass/controllers/reset_pass_controller.dart';

class ResetPasswordView extends GetView<ResetPasswordController> {
  const ResetPasswordView({super.key});


  //final emailC = Get.put(ResetPasswordController());
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logo.png",
              height: 80,
              width: 250,
            ),
            // Text(
            //   "Welcome",
            //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            // ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 55,
              width: 310,
              padding: EdgeInsets.all(13),
              decoration: BoxDecoration(
                  border: Border.all(color: Color(0xA56FCF97)),
                  borderRadius: BorderRadius.circular(20)),
              child: TextFormField(
                controller: controller.emailC,
                decoration: InputDecoration.collapsed(
                    hintText: "Email", border: InputBorder.none),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              height: 20,
            ),
            Text.rich(
              TextSpan(children: [
                TextSpan(text: "Have an account? " ''),
                TextSpan(
                    text: 'Login',
                    style: TextStyle(
                        color: Colors.lightGreen[600],
                        fontWeight: FontWeight.bold),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => Get.offAndToNamed(Routes.LOGIN)
                      ),
              ]),
            ),

            const SizedBox(
              height: 30,
            ),
            Container(
              height: 50,
              width: 190,
              padding: EdgeInsets.zero,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(40)),
              child: TextButton(
                onPressed: () => controller.resetPassword(controller.emailC.text),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.lightGreen[500],
                ),
                child: const Text(
                  "RESET",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w800),
                ),
              ),
            ),

            SizedBox(
              height: 20,
            ),
          ],
        ),
      )),
    );
  }
}
