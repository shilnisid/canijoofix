import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: Center(
        child: Obx((){
          if (controller.currentUser.value !=null) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Anda login sebagai',
                    style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 20),
                CircleAvatar(
                backgroundImage: NetworkImage(controller.currentUser.value!.photoUrl!),
                radius: 80,),
                const SizedBox(height: 20),
                Text('Nama : ${controller.currentUser.value!
                    .displayName}',
                    style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 20),
                Text('Email: ${controller.currentUser.value!.email}',
                    style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                    onPressed: controller.signOut,
                  icon: const Icon(Icons.logout),
                  label: const Text('Sign Out'),
                ),

              ],
            );
          }else if (controller.userProfile.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Anda login dengan email: ${controller.userProfile['email']}',
                      style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 20),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        })
      ),
    );
  }
}
