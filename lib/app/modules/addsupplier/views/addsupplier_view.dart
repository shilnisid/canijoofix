import '../../../modules/addsupplier/controllers/addsupplier_controller.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:flutter/material.dart';


class AddsupplierView extends GetView<AddsupplierController> {
  const AddsupplierView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('tambah kontak supplier'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: controller.namaSupplierController,
                decoration: const InputDecoration(
                  labelText: 'Nama Kontak',

                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                maxLength: 13,
                maxLines: 1,
                controller: controller.nomorSupplierController,
                decoration: const InputDecoration(
                  labelText: 'Nomor Kontak',
                  hintText: '62',
                ),
              ),
              SizedBox(
                height: 15,
              ),

              ElevatedButton(
                onPressed: () => controller.addSupplier(
                  controller.namaSupplierController.text,
                  controller.nomorSupplierController.text,

                ),
                child: Text('Tambah Kontak'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}