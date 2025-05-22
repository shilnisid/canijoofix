import 'package:cloud_firestore/cloud_firestore.dart';


import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
class BahanBakuController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  

  Stream<QuerySnapshot> streamData() async* {
    CollectionReference bahanBaku = firestore.collection('bahanBaku');
    yield* bahanBaku.snapshots();
  }

  Future<QuerySnapshot<Object?>> getData() async {
    CollectionReference bahanBaku = firestore.collection('bahanBaku');

    return bahanBaku.get();


  }


  void printAsPdf() async {
    final doc = pw.Document();
    CollectionReference bahanBakuPdf = firestore.collection('bahanBaku');
    QuerySnapshot<Object?> snapshot = await bahanBakuPdf.get();
    NumberFormat formatJumlah = NumberFormat("#,##0");
    final dibuat = DateFormat.jm().add_yMMMd().format(DateTime.now().toLocal());

    final header = [
      'Nama Bahan',
      'Jumlah',
      'Harga',
      'Dibuat',
      'Diubah',
      'Exp',
    ];

    final data = snapshot.docs.map((doc) {
      return[
      doc.get('namaBahan'),
      '${formatJumlah.format(doc.get('jumlah'))} gram',
      'Rp${doc.get('harga')}',
      doc.get('dibuat'),
      doc.get('diubah'),
      doc.get('exp'),
    ];
    }).toList();

    doc.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              children: [
                pw.SizedBox(height: 20),
                pw.Text('Daftar bahanBaku', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 20),
                pw.TableHelper.fromTextArray(
                  headers: header,
                  data: data,
                  border: pw.TableBorder(
                      horizontalInside: pw.BorderSide(width: 1, color: PdfColors.black),
                      verticalInside: pw.BorderSide(width: 1.8, color: PdfColors.black),
                      top: pw.BorderSide(width: 1.8, color: PdfColors.black),
                      right: pw.BorderSide(width: 1.8, color: PdfColors.black),
                      left: pw.BorderSide(width: 1.8, color: PdfColors.black),
                      bottom: pw.BorderSide(width: 1.8, color: PdfColors.black)),
                  headerStyle: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
                  cellAlignment: pw.Alignment.centerLeft,
                    cellPadding: pw.EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                  columnWidths: {
                    0: pw.FlexColumnWidth(3),
                    1: pw.FlexColumnWidth(2.8),
                    2: pw.FlexColumnWidth(2.5),
                    3: pw.FlexColumnWidth(3),
                    4: pw.FlexColumnWidth(3),
                    5: pw.FlexColumnWidth(3),
                  }
                ),
                pw.SizedBox(height: 200),
                pw.Text('printed on:$dibuat'),
              ],
            );
          },
        ),
    );




    await Printing.layoutPdf(name: 'bahan_baku', onLayout: (PdfPageFormat format) async => doc.save());
    //await Printing.sharePdf(bytes: await doc.save(), filename: 'bahan_baku.pdf');
  }

  
}




