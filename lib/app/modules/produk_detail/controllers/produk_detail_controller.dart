import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProdukDetailController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final RxMap<String, RxInt> jumlahProduk = <String, RxInt>{}.obs;
  final RxList<Map<String, dynamic>> komposisiList =
      <Map<String, dynamic>>[].obs;
  final NumberFormat numberFormat = NumberFormat.decimalPattern('id_ID');

  RxBool isInitialized = false.obs;

  String get diupdate =>
      DateFormat.jm().add_yMMMd().format(DateTime.now().toLocal());

  String? productId;
  String? docId;
  String namaProduk = '';
  String satuan = '';
  late DocumentReference updateListBahanBaku =
      firestore.collection('bahanBaku').doc(docId);

  @override
  void onInit() {
    super.onInit();
    initializeController();
  }

  Future<void> initializeController() async {
    updateListBahanBaku = firestore.collection('produk').doc(productId);
    try {
      // Ensure arguments are passed
      if (Get.arguments == null) {
        throw Exception('No arguments provided');
      }

      final arguments = Get.arguments as Map<String, dynamic>;
      productId = arguments['productId'] as String;
      namaProduk = arguments['namaProduk'] as String;

      // Safely map bahan baku list
      List<Map<String, dynamic>> bahanBakuList =
          ((arguments['bahanBaku'] as List<dynamic>?) ?? [])
              .map((bahan) => {
                    'namaBahan': bahan['namaBahan'] ?? '',
                    'jumlah': bahan['jumlah'] ?? 0,
                    'satuan': satuan,
                  })
              .toList();

      // Clear and add to listKomposisi
      komposisiList.clear();
      komposisiList.addAll(bahanBakuList);

      // Load jumlah produk
      await loadJumlahProduk();

      // Set default jumlah produk if not exists
      if (!jumlahProduk.containsKey(productId)) {
        jumlahProduk[productId!] = RxInt(arguments['jumlahBahan'] as int? ?? 0);
      }

      // Mark as initialized
      isInitialized.value = true;
    } catch (e) {
      print('Initialization Error: $e');
      Get.snackbar('Error', 'Gagal menginisialisasi controller: $e');
      isInitialized.value = false;
    }
  }

  Future<void> decrementJumlahProduk() async {
  if (!jumlahProduk.containsKey(productId) || productId == null) return;
  
  try {
    await firestore.runTransaction((transaction) async {
      // Get current product data
      DocumentReference produkRef = firestore.collection('produk').doc(productId);
      DocumentSnapshot produkDoc = await transaction.get(produkRef);

      if (!produkDoc.exists) {
        throw Exception('Produk tidak ditemukan');
      }

      var currentValue = jumlahProduk[productId]!.value;
      if (currentValue <= 0) {
        throw Exception('Jumlah produk tidak boleh kurang dari 0');
      }

      // Update product quantity
      jumlahProduk[productId]!.value--;
      
      // Update product document
      transaction.update(produkRef, {
        'jumlahProduk': jumlahProduk[productId]!.value,
        'diubah': diupdate,
      });

      // Return bahan baku to stock
      await updateBahanBaku(transaction, komposisiList, isIncrement: false);

      // Save to SharedPreferences
      await saveJumlahProduk();

      Get.snackbar(
        'Berhasil',
        'Jumlah produk berhasil dikurangi',
        snackPosition: SnackPosition.TOP,
      );
    });
  } catch (e) {
    print('Error decrementing jumlah: $e');
    Get.snackbar(
      'Error',
      'Gagal mengurangi jumlah produk: ${e.toString()}',
      snackPosition: SnackPosition.TOP,
    );
  }
}

  Future<void> incrementJumlahProduk() async {
  if (!jumlahProduk.containsKey(productId) || productId == null) return;

  try {
    // Check if enough bahan baku is available
    if (!await checkBahanBakuTersedia()) {
      throw Exception('Stok bahan baku tidak mencukupi');
    }

    await firestore.runTransaction((transaction) async {
      // Get current product data
      DocumentReference produkRef = firestore.collection('produk').doc(productId);
      DocumentSnapshot produkDoc = await transaction.get(produkRef);

      if (!produkDoc.exists) {
        throw Exception('Produk tidak ditemukan');
      }

      // Update product quantity
      jumlahProduk[productId]!.value++;
      
      // Update product document
      transaction.update(produkRef, {
        'jumlahProduk': jumlahProduk[productId]!.value,
        'diubah': diupdate,
      });

      // Deduct bahan baku from stock
      await updateBahanBaku(transaction, komposisiList, isIncrement: true);

      // Save to SharedPreferences
      await saveJumlahProduk();

      Get.snackbar(
        'Berhasil',
        'Jumlah produk berhasil ditambah',
        snackPosition: SnackPosition.TOP,
      );
    });
  } catch (e) {
    print('Error incrementing jumlah: $e');
    Get.snackbar(
      'Error',
      'Gagal menambah jumlah produk: ${e.toString()}',
      snackPosition: SnackPosition.TOP,
    );
  }
}

  Future<void> updateKomposisi(
      String productId, List<Map<String, dynamic>> newKomposisi) async {
    try {
      await firestore.runTransaction((transaction) async {
        // 1. Get product document reference
        DocumentReference produkRef =
            firestore.collection('produk').doc(productId);
        DocumentSnapshot produkDoc = await transaction.get(produkRef);

        if (!produkDoc.exists) {
          throw Exception('Produk tidak ditemukan');
        }

        // 2. Format komposisi data with bahan baku data
        Map<String, dynamic> komposisiMap = {};
        for (var i = 0; i < newKomposisi.length; i++) {
          // Get current bahan baku data
          var bahanBakuData =
              await getBahanBakuData(newKomposisi[i]['namaBahan'] as String);

          komposisiMap['bahan${i + 1}'] = {
            ...newKomposisi[i],
            'exp': DateFormat.jm()
                .add_yMMMd()
                .format(DateTime.now().add(const Duration(days: 30)).toLocal()),
            'dibuat': FieldValue.serverTimestamp(),
            'diubah': diupdate,
            'stok': bahanBakuData['jumlah'],
          };
        }

        // 3. Update product document
        transaction.update(produkRef, {
          'komposisiProduk': komposisiMap,
          'diubah': diupdate,
        });

        // 4. Update bahan baku documents
        await updateBahanBaku(transaction, newKomposisi, isIncrement: true);

        // 5. Update local state
        komposisiList.clear();
        komposisiList.addAll(newKomposisi);

        Get.snackbar(
          'Berhasil',
          'Komposisi produk berhasil diperbarui',
          snackPosition: SnackPosition.TOP,
        );
      });
    } catch (e) {
      print('Error updating komposisi: $e');
      Get.snackbar(
        'Error',
        'Gagal memperbarui komposisi: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
      );
      rethrow;
    }
  }

  Future<void> tambahKomposisi(Map<String, dynamic> newBahan) async {
    try {
      List<Map<String, dynamic>> updatedKomposisi = [...komposisiList];
      updatedKomposisi.add(newBahan);

      await updateKomposisi(productId!, updatedKomposisi);
    } catch (e) {
      Get.log('Error adding komposisi: $e');
      rethrow;
    }
  }

  Future<void> hapusKomposisi(int index) async {
    try {
      List<Map<String, dynamic>> updatedKomposisi = [...komposisiList];
      updatedKomposisi.removeAt(index);

      await updateKomposisi(productId!, updatedKomposisi);
    } catch (e) {
      Get.log('Error removing komposisi: $e');
      rethrow;
    }
  }

  Future<void> updateBahanBaku(
      Transaction transaction, List<Map<String, dynamic>> komposisiList,
      {required bool isIncrement}) async {
    try {
      for (var komposisi in komposisiList) {
        final String namaBahan = komposisi['namaBahan'].toString();
        final int jumlahPenggunaan = (komposisi['jumlah'] as num).toInt();

        // Get bahan baku document
        var docQueryBahan = await firestore
            .collection('bahanBaku')
            .where('namaBahan', isEqualTo: namaBahan)
            .limit(1)
            .get();

        if (docQueryBahan.docs.isEmpty) {
          throw Exception('Bahan baku $namaBahan tidak ditemukan');
        }

        var bahanBakuDoc = docQueryBahan.docs.first;
        int currentStock = (bahanBakuDoc.data()['jumlah'] as num).toInt();

        // Calculate new stock
        int updatedStock = isIncrement
            ? currentStock - jumlahPenggunaan
            : currentStock + jumlahPenggunaan;

        if (updatedStock < 0) {
          throw Exception('Stok bahan baku $namaBahan tidak mencukupi');
        }

        // Update bahan baku document
        transaction.update(bahanBakuDoc.reference, {
          'jumlah': updatedStock,
          'diubah': diupdate,
        });
      }
    } catch (e) {
      print('Error in updateBahanBaku: $e');
      rethrow;
    }
  }

  Future<bool> checkBahanBakuTersedia() async {
    if (komposisiList.isEmpty) return true;

    try {
      for (var bahan in komposisiList) {
        final String? namaBahan = bahan['namaBahan']?.toString();
        final num? jumlahDibutuhkan = bahan['jumlah'] as int?;

        if (namaBahan == null || jumlahDibutuhkan == null) {
          throw Exception('Data bahan baku tidak lengkap');
        }

        var doc = await getBahanBakuData(namaBahan);

        final int currentJumlahBahan = (doc['jumlah'] as num).toInt();

        if (currentJumlahBahan < jumlahDibutuhkan) {
          throw Exception(
              'Stok bahan baku $namaBahan tidak mencukupi (Tersedia: $currentJumlahBahan, Dibutuhkan: $jumlahDibutuhkan)');
        }
      }
      return true;
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return false;
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

  Future<void> loadJumlahProduk() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final DocumentSnapshot produkDoc =
          await firestore.collection('produk').doc(productId).get();

      if (produkDoc.exists) {
        final int storedJumlah = prefs.getInt('jumlahProduk_$productId') ??
            (produkDoc.data() as Map<String, dynamic>?)?['jumlah'] as int? ??
            0;
        jumlahProduk[productId!] = RxInt(storedJumlah);
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat data produk: ${e.toString()}');
    }
  }

  Future<void> saveJumlahProduk() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt(
          'jumlahProduk_$productId', jumlahProduk[productId]?.value ?? 0);
    } catch (e) {
      Get.snackbar('Error', 'Gagal menyimpan data produk: ${e.toString()}');
    }
  }

  Future<void> deleteProduk() async {
    try {
      await firestore.collection('produk').doc(productId).delete();

      Get.snackbar('Berhasil', 'Produk berhasil dihapus');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghapus produk: $e');
    }
  }
}
