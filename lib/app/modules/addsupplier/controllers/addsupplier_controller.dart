import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AddsupplierController extends GetxController {
  //TODO: Implement AddProdukDeskripsiController

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  late final TextEditingController namaSupplierController;
  late final TextEditingController nomorSupplierController;


  void addSupplier(String supplierName, String supplierNumber) async {
    CollectionReference supplier = firestore.collection('supplier');

    String supplierName = namaSupplierController.text;
    String supplierNumber = nomorSupplierController.text;

    if (supplierName.isEmpty || supplierNumber.isEmpty) {
      Get.defaultDialog(
        title: 'Terjadi Kesalahan',
        middleText: 'Nama atau nomor supplier tidak boleh kosong',
      );
      return;
    }


    try {
      await supplier.add({
        'supplierName': supplierName,
        'supplierNumber': supplierNumber,
      });
      Get.defaultDialog(
        title: 'Berhasil',
        middleText: 'Berhasil menambahkan kontak',
        onConfirm: () {
          namaSupplierController.clear();
          nomorSupplierController.clear();
          Get.back();
          Get.back();
        },
        textConfirm: 'Okay',
      );
    } catch (e) {
      print(e);
      return Get.defaultDialog(
        title: 'Terjadi Kesalahan',
        middleText: 'Gagal menambahkan kontak',
      );
    }
  }


  @override
  void onInit() {
    namaSupplierController = TextEditingController();
    nomorSupplierController = TextEditingController();

    super.onInit();
  }

  @override
  void onClose() {
    namaSupplierController.dispose();
    nomorSupplierController.dispose();

    super.onClose();
  }
}