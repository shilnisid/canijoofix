import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddProdukDetailController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String get diupdate =>
      DateFormat.jm().add_yMMMd().format(DateTime.now().toLocal());

  late TextEditingController namaProduk;
  late TextEditingController komposisiNama;
  late TextEditingController komposisiJumlah;
  late TextEditingController komposisiSatuan;

  final RxInt jumlahProduk = 0.obs;
  final RxList<Map<String, dynamic>> listKomposisi = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> listBahan = <Map<String, dynamic>>[].obs;

  void tambahKomposisi(String nama, int jumlah, String satuan) {
    listKomposisi.add({
      'nama': nama,
      'jumlah': jumlah,
      'satuan': satuan,
    });

    // Reset field komposisi
    komposisiNama.clear();
    komposisiJumlah.clear();
    komposisiSatuan.clear();
  }

  void tambahBahan(String namaBahan, int jumlah, String satuan) {
    listBahan.add({
      'namaBahan': namaBahan,
      'jumlah': jumlah,
      'satuan': satuan,
      'exp': DateFormat.jm()
          .add_yMMMd()
          .format(DateTime.now().add(const Duration(days: 30)).toLocal()),
      'dibuat': FieldValue.serverTimestamp(),
      'diubah': diupdate,
    });
  }

  void hapusKomposisi(int index) {
    listKomposisi.removeAt(index);
  }

  void resetKomposisi() {
    namaProduk.clear();
    listKomposisi.clear();
    listBahan.clear();
  }

  Future<void> updateBahanBaku(List<Map<String, dynamic>> komposisiList, {required bool isIncrement}) async {
    try {
      for (var komposisi in komposisiList) {
        String namaBahan = komposisi['nama'].toString();
        int jumlahPenggunaan = (komposisi['jumlah'] as num).toInt();

        var querySnapshot = await firestore
            .collection('bahanBaku')
            .where('namaBahan', isEqualTo: namaBahan)
            .limit(1)
            .get();

        if (querySnapshot.docs.isEmpty) {
          throw Exception('Bahan baku $namaBahan tidak ditemukan');
        }

        var bahanBakuDoc = querySnapshot.docs.first;
        int currentStock = (bahanBakuDoc.data()['jumlah'] as num).toInt();
        int updatedStock = isIncrement ? currentStock - jumlahPenggunaan : currentStock + jumlahPenggunaan;

        if (updatedStock < 0) {
          throw Exception('Stok bahan baku $namaBahan tidak mencukupi');
        }

        await bahanBakuDoc.reference.update({'jumlah': updatedStock});
      }
    } catch (e) {
      throw Exception('Gagal mengupdate bahan baku: $e');
    }
  }

  Future<Map<String, dynamic>> getBahanBakuData(String namaBahan) async {
    var querySnapshot = await firestore
        .collection('bahanBaku')
        .where('namaBahan', isEqualTo: namaBahan)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      throw Exception('Bahan baku $namaBahan tidak ditemukan');
    }

    return querySnapshot.docs.first.data();
  }

  void addProdukDetail(String namaProduk, String namaBahan) async {
    CollectionReference produk = firestore.collection('produk');
    try {
      Map<String, dynamic> komposisiMap = {};
      for (var i = 0; i < listKomposisi.length; i++) {
        var bahanBakuData = await getBahanBakuData(listKomposisi[i]['nama'] as String);
        komposisiMap['bahan${i + 1}'] = {
          ...listKomposisi[i],
          'exp': DateFormat.jm()
              .add_yMMMd()
              .format(DateTime.now().add(const Duration(days: 30)).toLocal()),
          'dibuat': FieldValue.serverTimestamp(),
          'diubah': diupdate,
          'stok': bahanBakuData['jumlah'],
        };
      }

      await produk.add({
        'namaProduk': namaProduk,
        'komposisiProduk': komposisiMap,
        'jumlahProduk': jumlahProduk.value,
        'dibuat': FieldValue.serverTimestamp(),
        'diubah': diupdate
      });

      // Update bahan baku
      await updateBahanBaku(listKomposisi, isIncrement: true);

      Get.defaultDialog(
        title: 'Berhasil',
        middleText: 'Berhasil menambahkan produk',
        onConfirm: () {
          this.namaProduk.clear();
          listKomposisi.clear();
          listBahan.clear();

          Get.back();
          Get.back();
        },
        textConfirm: 'Okay',
      );
    } catch (e) {
      print(e);
      if (namaProduk.isEmpty && namaProduk.isEmpty) {
        return Get.back();
      }
      return Get.defaultDialog(
        title: 'Terjadi Kesalahan',
        middleText: 'Gagal menambahkan Produk',
      );
    }
  }

  Future<void> deleteProdukDetail(String produkId) async {
    CollectionReference produk = firestore.collection('produk');
    try {
      DocumentSnapshot produkDoc = await produk.doc(produkId).get();
      if (!produkDoc.exists) {
        throw Exception('Produk tidak ditemukan');
      }

      Map<String, dynamic> komposisiMap = (produkDoc.data() as Map<String, dynamic>)['komposisiProduk'] as Map<String, dynamic>;
      List<Map<String, dynamic>> komposisiList = komposisiMap.values.map((e) => e as Map<String, dynamic>).toList();

      // Update bahan baku
      await updateBahanBaku(komposisiList, isIncrement: false);

      // Delete produk
      await produk.doc(produkId).delete();

      Get.defaultDialog(
        title: 'Berhasil',
        middleText: 'Berhasil menghapus produk',
        onConfirm: () {
          Get.back();
        },
        textConfirm: 'Okay',
      );
    } catch (e) {
      print(e);
      return Get.defaultDialog(
        title: 'Terjadi Kesalahan',
        middleText: 'Gagal menghapus Produk',
      );
    }
  }

  @override
  void onInit() {
    super.onInit();
    namaProduk = TextEditingController();
    komposisiNama = TextEditingController();
    komposisiJumlah = TextEditingController();
    komposisiSatuan = TextEditingController();
  }

  @override
  void onClose() {
    namaProduk.dispose();
    komposisiNama.dispose();
    komposisiJumlah.dispose();
    komposisiSatuan.dispose();
    super.onClose();
  }
}