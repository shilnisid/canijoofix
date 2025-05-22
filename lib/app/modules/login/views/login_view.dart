import '../../../modules/login/controllers/login_controller.dart';
import '../../../routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';


class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  //final TextEditingController emailC = TextEditingController();
  //final TextEditingController passC = TextEditingController();
  //final User? auth = FirebaseAuth.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;

  final controller = Get.put(LoginController());
  // signup() async {
  //   try {
  //     await auth.createUserWithEmailAndPassword(
  //       email: controller.emailC.text.toString().trim(),
  //       password: controller.passC.text,
  //     );
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
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
              height: 40,
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
                textInputAction: TextInputAction.next,
                controller: controller.emailC,
                decoration: InputDecoration.collapsed(
                    hintText: "Email", border: InputBorder.none),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              height: 55,
              width: 310,
              padding: EdgeInsets.all(13),
              decoration: BoxDecoration(
                  border: Border.all(color: Color(0xA56FCF97)),
                  borderRadius: BorderRadius.circular(20)),
              child: Obx(
                () => TextFormField(
                  obscureText: !controller.isPasswordVisible.value,
                  controller: controller.passC,
                  decoration: InputDecoration(
                      hintText: "Password",
                      border: InputBorder.none,
                      isCollapsed: true,
                      suffixIcon: IconButton(
                        onPressed: controller.handleShowPassword,
                        icon: Icon(Icons.remove_red_eye),
                        padding: EdgeInsets.zero,
                      )),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text.rich(
              TextSpan(children: [
                TextSpan(text: "Forgot Password? " ''),
                TextSpan(
                    text: 'Reset Password',
                    style: TextStyle(
                        color: Colors.lightGreen[600],
                        fontWeight: FontWeight.bold),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => Get.toNamed(Routes.RESET_PASS)),
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
                onPressed: ()  {
                  
                  controller.login();
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.lightGreen[500],
                ),
                child: const Text(
                  "Sign in",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w800),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text.rich(
              TextSpan(children: [
                TextSpan(text: "Don't have an account? " ''),
                TextSpan(
                    text: 'Sign up',
                    style: TextStyle(
                        color: Colors.lightGreen[600],
                        fontWeight: FontWeight.bold),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => Get.offAndToNamed(Routes.SIGNUP)),
              ]),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 20,
              child:
                  Text.rich(TextSpan(text: "-----or with Sign in with-----")),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              alignment: Alignment.center,
              height: 50,
              width: 184,
              //padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Colors.white,
                  border: Border.all(color: Colors.black)),
              child: TextButton(
                onPressed: () {
                  controller.signInWithGoogle();
                },
                child: 
                SvgPicture.asset("assets/images/android_light_rd_SI.svg",  fit: BoxFit.none, )
              ),
            ),

          ],
        ),
      )),
    );
  }
}
