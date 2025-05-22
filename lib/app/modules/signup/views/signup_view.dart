import '../../..//routes/app_pages.dart';
import '../../../modules/signup/controllers/signup_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  _SignupViewState createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  // final TextEditingController emailC = TextEditingController();
  // final TextEditingController passC = TextEditingController();
  // final FirebaseAuth auth = FirebaseAuth.instance;
  final controller = Get.put(SignUpController());

  // login() {
  //   try {
  //     auth
  //         .signInWithEmailAndPassword(
  //             email: controller.emailC.text, password: controller.passC.text)
  //         .then((value) => Get.offAndToNamed(RouteName.HOME));
  //     Get.snackbar('Login', 'Welocome!');
  //   } catch (e) {
  //     print(e);
  //   }
  // }
  //final _formKey = GlobalKey<FormState>();
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
            // // Text(
            // //   "Welcome",
            // //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
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
                textInputAction: TextInputAction.next,
                controller: controller.emailC,
                decoration: InputDecoration.collapsed(hintText: "Email"),
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
                  textInputAction: TextInputAction.next,
                  obscureText: !controller.isPasswordVisible.value,
                  controller: controller.passC,
                  keyboardType: TextInputType.emailAddress,
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
                  textInputAction: TextInputAction.next,
                  obscureText: !controller.isPasswordVisible.value,
                  controller: controller.passC2,
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
            const SizedBox(
              height: 26,
            ),
            // Container(
            //   height: 50,
            //   width: 290,
            //   padding: EdgeInsets.zero,
            //   decoration:
            //       BoxDecoration(borderRadius: BorderRadius.circular(20)),
            //   child: TextButton(
            //     onPressed: () {
            //       login();
            //     },
            //     child: const Text(
            //       "Login",
            //       style: TextStyle(
            //           color: Colors.white, fontWeight: FontWeight.w600),
            //     ),
            //     style: TextButton.styleFrom(
            //       backgroundColor: Colors.green[400],
            //     ),
            //   ),
            // ),
            // SizedBox(
            //   height: 20,
            // ),
            Container(
              height: 50,
              width: 190,
              padding: EdgeInsets.zero,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                onPressed: () {
                  controller.passC2.text != controller.passC.text
                      ? Get.snackbar('Password', 'password not match!')
                      : controller.signup();
                  controller.emailC.text.isEmpty &&
                          controller.passC.text.isEmpty
                      ? Get.snackbar('Empty field', 'field can not empty')
                      : controller.signup();
                },
                style: TextButton.styleFrom(
                    backgroundColor: Colors.lightGreen[500]),
                child: const Text(
                  "Sign up",
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
                TextSpan(text: 'Already have an account? ' ''),
                TextSpan(
                    text: 'Login',
                    style: TextStyle(
                        color: Colors.lightGreen[600],
                        fontWeight: FontWeight.bold),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => Get.offAndToNamed(Routes.LOGIN)),
              ]),
            ),
          ],
        ),
      )),
    );
  }
}
