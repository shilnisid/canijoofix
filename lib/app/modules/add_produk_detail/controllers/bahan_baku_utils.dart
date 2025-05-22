import 'package:cloud_firestore/cloud_firestore.dart';

class BahanBakuUtils {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<void> updateBahanBaku(List<Map<String, dynamic>> listKomposisi, bool isIncrement) async {
    final batch = firestore.batch();

    try {
      for (var komposisi in listKomposisi) {
        String? namaBahan = komposisi['namaBahan'].toString();
        int? jumlahPenggunaan = (komposisi['jumlah'] as num).toInt();

        // Cari dokumen bahan baku
        final query = await firestore
            .collection('bahanBaku')
            .where('namaBahan', isEqualTo: namaBahan)
            .limit(1)
            .get();

        if (query.docs.isEmpty) {
          throw Exception('Bahan baku $namaBahan tidak ditemukan');
        }

        final bahanBakuDoc = query.docs.first;
        final int stokSaatIni = (bahanBakuDoc['jumlah'] as int?) ?? 0;

        int updatedStok = isIncrement ? stokSaatIni - jumlahPenggunaan : stokSaatIni + jumlahPenggunaan;

        if (updatedStok < 0) {
          throw Exception('Stok bahan baku $namaBahan tidak mencukupi');
        }

        batch.update(bahanBakuDoc.reference, {'jumlah': updatedStok});
      }

      await batch.commit();
    } catch (e) {
      print('Error in updateBahanBaku: $e');
      rethrow;
    }
  }
}
