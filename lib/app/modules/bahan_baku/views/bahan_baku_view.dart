
import '../../../routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/bahan_baku_controller.dart';

class BahanBakuView extends GetView<BahanBakuController> {
  
  const BahanBakuView({super.key});
   
  @override
  Widget build(BuildContext context) {
    return GetBuilder<BahanBakuController>(
      init: BahanBakuController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Bahan baku'),
            centerTitle: true,
            actions: [
              Text('Print', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              IconButton(
                icon: Icon(Icons.print_outlined),
                onPressed: () {
                  controller.printAsPdf();
                },
              )
            ],
          ),
          body: StreamBuilder<QuerySnapshot<Object?>>(
            stream: controller.streamData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                var listAllDocs = snapshot.data!.docs;
                return ListView.builder(
                  clipBehavior: Clip.antiAlias,
                  itemCount: listAllDocs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      isThreeLine: true,
                      title: Text(
                          "${(listAllDocs[index].data() as Map<String, dynamic>)['namaBahan']}", style: TextStyle(fontSize: 20),),
                      subtitle: Text(
                          "Jumlah ${(listAllDocs[index].data() as Map<String, dynamic>)['jumlah']} Gram" 
                          "\nHarga Rp${(listAllDocs[index].data() as Map<String, dynamic>)['harga']}" 
                          "\nCreated At : ${(listAllDocs[index].data() as Map<String,dynamic>)['dibuat']}" 
                          "\nUpdated At : ${(listAllDocs[index].data() as Map<String, dynamic>)['diubah']}"
                          "\nExpired At : ${(listAllDocs[index].data() as Map<String, dynamic>)['exp']}", style: TextStyle(fontSize: 16)),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Get.toNamed(Routes.EDIT_BAHAN_BAKU,
                              arguments: listAllDocs[index].id);
                        },
                      ),
                    );
                  },
                );
              }
              return Center(
                  child:
                      CircularProgressIndicator(color: Colors.lightGreen[200]));
            },
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.lightGreen[200],
            child: Icon(Icons.add),
            onPressed: () {
              Get.toNamed(Routes.ADDBAHAN_BAKU,
                  arguments: controller.getData());
            },
          ),
        );
      },
    );
  }
}
