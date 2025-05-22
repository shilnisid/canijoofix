import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class AddbahanBakuController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  late TextEditingController jenisC;
  late TextEditingController hargaC;
  late TextEditingController jumlahC;

  NumberFormat numberFormat = NumberFormat.decimalPattern('id_ID');

  final dibuat = DateFormat.jm().add_yMMMd().format(DateTime.now().toLocal());
  late final expired = DateFormat.jm()
      .add_yMMMd()
      .format(DateTime.now().add(Duration(days: 30)).toLocal());

  void addBahanBaku(
      String namaBahan, double harga, int jumlah, String dibuat, exp) async {
    CollectionReference bahanBaku = firestore.collection('bahanBaku');

    print(numberFormat.format(jumlah));
    print(jumlah);

    try {
      await bahanBaku.add({
        'namaBahan': namaBahan,
        'jumlah': jumlah,
        'harga': numberFormat.format(harga),
        'dibuat': dibuat,
        'exp': expired
      });
      Get.defaultDialog(
        title: 'Berhasil',
        middleText: 'Berhasil menambahkan bahan baku',
        onConfirm: () {
          jenisC.clear();
          hargaC.clear();
          jumlahC.clear();
          Get.back();
          Get.back();
        },
        textConfirm: 'Okay',
      );
    } catch (e) {
      Get.defaultDialog(
        title: 'Terjadi Kesalahan',
        middleText: 'Gagal menambahkan bahan baku',
      );
    }
  }

  @override
  void onInit() {
    jenisC = TextEditingController();
    hargaC = TextEditingController();
    jumlahC = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    jenisC.dispose();
    hargaC.dispose();
    jumlahC.dispose();
    super.onClose();
  }
}
