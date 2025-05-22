import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../addsupplier/controllers/addsupplier_controller.dart';

class SupplierController extends GetxController {
  //TODO: Implement SupplierController

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  late final AddsupplierController supplierDB;

  @override
  void onInit() {
    super.onInit();
    supplierDB = Get.put(AddsupplierController());
  }

  Stream<QuerySnapshot> streamDataSupplier(String supplierId) async* {
    CollectionReference supplier = firestore.collection('supplier');
    yield* supplier.snapshots();
  }

  Future<void> toWa(String phoneNumber) async {
     await firestore.collection('supplier').where('supplierNummber', isEqualTo: phoneNumber).get();
    Uri whatsApp = Uri.parse('https://wa.me/$phoneNumber');

    if (phoneNumber.isEmpty) {
      // Jika nomor supplier null atau kosong, berikan pesan error
      Get.snackbar('Error', 'Nomor WhatsApp tidak ditemukan.');
      return;
    }

    if (await canLaunchUrl(whatsApp)) {
      await launchUrl(whatsApp, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar(
        'Error',
        'Tidak dapat membuka WhatsApp.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  Future<void> deleteSupplier(String supplierId) async {
    try {
      await firestore.collection('supplier').doc(supplierId).delete();
      Get.snackbar('Berhasil', 'berhasil menghapus supplier');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghapus Supplier');
    }
  }
}
  /*final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    toWa();
  }

  @override
  void onReady() {
    super.onReady();
  }



  void increment() => count.value++;*/

