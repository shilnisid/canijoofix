import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Welcome'),
            centerTitle: true,
          ),
          body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: controller.streamDataProduk(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.lightGreen[200],
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data == null) {
                return const Center(
                  child: Text('No data available'),
                );
              }

              final product = snapshot.data!.docs;

              if (product.isEmpty) {
                return const Center(
                  child: Text('No products found'),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: product.length,
                itemBuilder: (context, index) {
                  final docId = product[index].id;
                  final produk = product[index].data();

                  // Get the document ID

                  final namaProduk =
                      produk['namaProduk']?.toString() ?? 'Produk tidak diketahui';
                  final jumlahBahan = produk['jumlahBahan'] ?? 0;
                  final komposisi = controller.getKomposisi(namaProduk);

                  return Card(
                    elevation: 0,
                    color: Colors.transparent,
                    margin:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      title: Text(
                        namaProduk,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        komposisi,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.lightGreen[100],
                        child: Text(
                          namaProduk.isNotEmpty
                              ? namaProduk[0].toUpperCase() : '?',
                          style: TextStyle(
                            color: Colors.lightGreen[900],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.arrow_forward_ios_rounded),
                        onPressed: () {
                          Get.toNamed(
                            Routes.PRODUK_DETAIL,
                            arguments: {
                              'productId': docId, // document ID
                              'namaProduk': namaProduk,
                              'deskripsiProduk': komposisi,
                              'jumlahBahan': jumlahBahan,
                            },
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.lightGreen[200],
            child: const Icon(Icons.add),
            onPressed: () => Get.toNamed(Routes.ADD_PRODUK_DETAIL),
          ),
        );
      },
    );
  }
}
