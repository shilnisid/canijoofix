import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../routes/app_pages.dart';

class ProfileController extends GetxController {
  var userProfile = {}.obs;
  var googleSignIn = GoogleSignIn();
  // Fix: Consistent naming of currentUser variable
  var currentUser = Rx<GoogleSignInAccount?>(null);
 
  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
    googleSignIn.onCurrentUserChanged.listen((account) {
      currentUser.value = account;  // Using consistent naming
    });
    googleSignIn.signInSilently();
  }
  
  void fetchUserProfile() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('user')
          .doc(user.uid)
          .get();
      if (documentSnapshot.data() != null) {
        userProfile.assignAll(documentSnapshot.data() as Map<String, dynamic>);
      }
    }
  }

  Future<void> signIn() async {  // Changed from gsignIn to signIn for consistency
    try {
      currentUser.value = await googleSignIn.signIn();  // Using consistent naming
      if (currentUser.value != null) {
        Get.snackbar("Success", "User signed in successfully");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> signOut() async {
    await googleSignIn.signOut();
    currentUser.value = null;  // Using consistent naming
    Get.offAllNamed(Routes.LOGIN);
  }
}