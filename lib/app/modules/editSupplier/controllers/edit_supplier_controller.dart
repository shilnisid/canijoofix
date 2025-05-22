import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class EditSupplierController extends GetxController {
  //TODO: Implement EditSupplierController
  late TextEditingController newName;
  late TextEditingController newNumber;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> editSupplier(String supplierId, String newName, String newNumber) async {
    DocumentReference docData = firestore.collection('supplier').doc(supplierId);
    try {
      await docData.update({
        'supplierName': newName,
        'supplierNumber': newNumber,
      });
      Get.back(); // Close the edit screen (optional)
      Get.snackbar('Success', 'Supplier updated successfully.');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update supplier.');
      print(e);
    }
  }

  Future<DocumentSnapshot> getData(String docID) async {
    DocumentReference docRef = firestore.collection('supplier').doc(docID);
    return await docRef.get();
  }

  //final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    newName = TextEditingController();
    newNumber = TextEditingController();
  }


  @override
  void onClose() {
    // newNumber.dispose();
    // newName.dispose();
    super.onClose();
  }

  //void increment() => count.value++;
}
