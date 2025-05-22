import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Bahan-bahan dan jumlahnya
  static const int bahanKacang = 150;
  static const int bahanGula = 15;
  static const int bahanDaunPandan = 5;
  static const int bahanKrimerNabati = 20;
  static const int bahanGaram = 2;

  // Stream data produk dari Firebase
  Stream<QuerySnapshot<Map<String, dynamic>>> streamDataProduk() {
    return firestore.collection('produk').snapshots();
  }





  // Menghasilkan komposisi produk dengan nama produk yang diberikan
  String getKomposisi(String namaProduk) {
    final produkName = namaProduk.isNotEmpty ? namaProduk : 'Produk Tidak Diketahui';
    return '''
Komposisi per produk:
- $produkName: $bahanKacang gram
- Gula: $bahanGula gram
- Garam: $bahanGaram gram
- Krimer Nabati: $bahanKrimerNabati gram
- Daun Pandan: $bahanDaunPandan gram
''';
  }
}
