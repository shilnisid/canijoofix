import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/supplier_controller.dart';

class SupplierView extends GetView<SupplierController> {
  const SupplierView({super.key});

  @override
  Widget build(BuildContext context) {
    final supplierId = Get.arguments.toString();
    return GetBuilder<SupplierController>(
        init: SupplierController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Supplier'),
              centerTitle: true,
            ),
            body: StreamBuilder<QuerySnapshot<Object?>>(
                stream: controller.streamDataSupplier(supplierId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    var listAllDocs = snapshot.data!.docs;
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: listAllDocs.length,
                      itemBuilder: (context, index) {
                        final data =
                            listAllDocs[index].data() as Map<String, dynamic>;
                        final phoneNumber = data['supplierNumber'] as String;
                        final supplierName = data['supplierName'] as String;
                        return Slidable(
                          key: ValueKey(listAllDocs[index]
                              .id), // Unique key for each item
                          // Define the actions on the left (if any)
                          startActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) async {
                                  controller
                                      .deleteSupplier(listAllDocs[index].id);
                                },
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                icon: Icons.delete_forever,
                                label: 'Delete',
                              ),
                              SlidableAction(
                                onPressed: (context) async {
                                  Get.toNamed(Routes.EDIT_SUPPLIER,
                                      arguments: listAllDocs[index].id);
                                },
                                backgroundColor: Colors.blueGrey,
                                foregroundColor: Colors.white,
                                icon: Icons.edit,
                                label: 'Edit',
                              )
                            ],
                          ),
                          child: Card(
                            elevation: 0,
                            color: Colors.transparent,
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 10),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 12),
                              title: Text(
                                supplierName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Text(
                                '+$phoneNumber',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              
                              leading: CircleAvatar(
                                backgroundColor: Colors.lightGreen[200],
                                child: Text(data.isNotEmpty 
                                    ? supplierName[0].toUpperCase()
                                    + supplierName[9].toUpperCase()
                                    :'?',
                                  style: TextStyle(
                                    color: Colors.lightGreen[900],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.message_sharp),
                                onPressed: () async =>
                                    {controller.toWa(phoneNumber)},
                              ),
                            
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(
                        color: Colors.lightGreen[200]),
                  );
                }),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.lightGreen[200],
              child: const Icon(Icons.add),
              onPressed: () {
                Get.toNamed(Routes.ADDSUPPLIER);
              },
            ),
          );
        });
  }
}
