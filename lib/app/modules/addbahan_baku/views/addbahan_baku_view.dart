import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/addbahan_baku_controller.dart';
import '../controllers/thousand_separator_formatter.dart';

class AddbahanBakuView extends GetView<AddbahanBakuController> {
  const AddbahanBakuView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Bahan Baku'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: controller.jenisC,
              autocorrect: false,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'Nama Bahan Baku',
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: controller.jumlahC,
              autocorrect: false,
              keyboardType: TextInputType.numberWithOptions(decimal: true, signed: false),
              textInputAction: TextInputAction.next,
              inputFormatters: [ThousandSeparatorInputFormatter()],
              decoration: InputDecoration(
                suffixText: 'gram',
                labelText: 'Jumlah',
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: controller.hargaC,
              keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
              inputFormatters: [ThousandSeparatorInputFormatter()],
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                prefixText: 'Rp. ',
                labelText: 'Harga',
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Validasi input
                if (controller.jenisC.text.isEmpty ||
                    controller.jumlahC.text.isEmpty ||
                    controller.hargaC.text.isEmpty) {
                  Get.snackbar('Error', 'Semua field harus diisi');
                  return;
                }

                try {
                  final namaBahan = controller.jenisC.text;
                  final jumlah = int.parse(controller.jumlahC.text.replaceAll('.', ''));
                  final harga = double.parse(controller.hargaC.text.replaceAll('.', ''));

                  controller.addBahanBaku(
                    namaBahan,
                    harga,
                    jumlah,
                    controller.dibuat.toString(),
                    controller.expired,
                  );
                  Get.arguments.toString();
                } catch (e) {
                  Get.snackbar('Error', 'Input tidak valid');
                }
              },
              child: Text('Tambah Bahan Baku'),
            ),
          ],
        ),
      ),
    );
  }
}
