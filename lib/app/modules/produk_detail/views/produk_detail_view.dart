import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/produk_detail_controller.dart';

class ProdukDetailView extends GetView<ProdukDetailController> {
  const ProdukDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produk Detail'),
        centerTitle: true,
      ),
      body: GetBuilder<ProdukDetailController>(
        init: ProdukDetailController(),
        builder: (controller) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              clipBehavior: Clip.hardEdge,
              elevation: 20,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.black12),
                borderRadius: BorderRadius.circular(15),
              ),
              color: Colors.lightGreen[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Product Name
                    Text(
                      controller.namaProduk,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    
                    // Product Description
                    Text(
                      'Komposisi:',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 8),

                    Obx(() => ListView.builder(
                        shrinkWrap: true,
                        itemCount: controller.komposisiList.length,
                        itemBuilder: (context, index){
                          final komposisi = controller.komposisiList[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              title: Text(
                                komposisi['nama'].toString() ,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                '${controller.numberFormat.format(komposisi['jumlah'] ?? 0)} ${komposisi['satuan'] ?? 'gram'}',
                              ),
                            ),
                          );
                        })
                    ),
                    const SizedBox(height: 24),

                    //stock control
                    const Text(
                      'Stok Produk:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    // Quantity Controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline, size: 36),
                          highlightColor: Colors.red[200],
                          hoverColor: Colors.red[100],
                          onPressed: () => controller.decrementJumlahProduk,
                        ),
                        const SizedBox(width: 16),
                        Obx(() => Text(
                          '${controller.jumlahProduk[controller.productId]?.value ?? 0}',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline, size: 36),
                          highlightColor: Colors.lightGreen[200],
                          hoverColor: Colors.lightGreen[100],
                          onPressed: controller.incrementJumlahProduk,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Terakhir diubah: ${controller.diupdate}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red[400],
        child: const Icon(Icons.delete),
        onPressed: () => _showDeleteConfirmation(context),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    Get.defaultDialog<void>(
      title: "Konfirmasi Hapus",
      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
      middleText: "Apakah Anda yakin ingin menghapus produk ini?",
      contentPadding: const EdgeInsets.all(20),
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[400],
          foregroundColor: Colors.white,
        ),
        onPressed: () {
          controller.deleteProduk();
          Get.back<void>(); // Close dialog
        },
        child: const Text('Hapus'),
      ),
      cancel: OutlinedButton(
        onPressed: () => Get.back<void>(),
        child: const Text('Batal'),
      ),
    );
  }
}