import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/add_produk_detail_controller.dart';

class AddProdukDetailView extends GetView<AddProdukDetailController> {
  const AddProdukDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddProdukDetailController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finished Product Detail'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: controller.namaProduk,
                decoration: const InputDecoration(
                  labelText: 'Nama Produk',
                  border: OutlineInputBorder()
                ),
              ),
             const  SizedBox(
                height: 20,
              ),
              Card(
                color: Colors.lightGreen[50],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tambah Komposisi Bahan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: controller.komposisiNama,
                        decoration: const InputDecoration(
                          labelText: 'Nama Bahan',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextField(
                              controller: controller.komposisiJumlah,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                suffixText: 'gram',
                                labelText: 'Jumlah',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 1,
                            child: TextField(
                              controller: controller.komposisiSatuan,
                              decoration: const InputDecoration(
                                labelText: 'Satuan',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      const SizedBox(height: 10),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: (){
                            
                            if (controller.komposisiNama.text.isNotEmpty &&
                                controller.komposisiJumlah.text.isNotEmpty &&
                                controller.komposisiSatuan.text.isNotEmpty)
                            {
                              controller.listKomposisi.add({
                                'nama': controller.komposisiNama.text,
                                'jumlah': int.parse(controller.komposisiJumlah.text),
                                'satuan': controller.komposisiSatuan.text,
                              });
                            }
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Tambah Bahan'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const  SizedBox(
                height: 20,
              ),
              Obx(()=> Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Daftar Komposisi: ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics:  const NeverScrollableScrollPhysics(),
                    itemCount: controller.listKomposisi.length,
                    itemBuilder: (Context, index){
                      if (index >= controller.listKomposisi.length) {
                        return const SizedBox.shrink(); // Jangan tampilkan apapun jika index di luar
                      }
                      print('Panjang List Komposisi: ${controller.listKomposisi.length}');
                      final bahan = controller.listKomposisi[index];
                      return Card(
                        color: Colors.lightGreen[100],
                        child: ListTile(
                          title: Text(bahan['nama'].toString()),
                          subtitle: Text('${bahan['jumlah']} ${bahan['satuan'].toString()}'),
                          trailing: IconButton(
                              onPressed: () => controller.hapusKomposisi(index),
                              icon: const Icon(Icons.delete, color: Colors.red)),
                        ),
                      );
                    },
                  ),
                ],
                )),
              SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (controller.namaProduk.text.isNotEmpty &&
                          controller.listKomposisi.isNotEmpty
                      ){
                        controller.addProdukDetail(
                            controller.namaProduk.text,
                            controller.komposisiNama.text);
                      }else{
                        Get.snackbar('Error', 'Nama produk dan minimal satu bahan harus diisi',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
                    style:
                      ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                    child: const Text(
                      'Simpan Produk',
                      style: TextStyle(fontSize: 16),
                    ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/add_produk_detail_controller.dart';

class AddProdukDetailView extends GetView<AddProdukDetailController> {
  const AddProdukDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finished Product Detail'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: controller.namaProduk,
              decoration: const InputDecoration(
                labelText: 'Nama Produk',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Komposisi Input Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tambah Komposisi Bahan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: controller.komposisiNama,
                      decoration: const InputDecoration(
                        labelText: 'Nama Bahan',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: controller.komposisiJumlah,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Jumlah',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: TextField(
                            controller: controller.komposisiSatuan,
                            decoration: const InputDecoration(
                              labelText: 'Satuan',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (controller.komposisiNama.text.isNotEmpty &&
                              controller.komposisiJumlah.text.isNotEmpty &&
                              controller.komposisiSatuan.text.isNotEmpty) {
                            controller.tambahKomposisi(
                              controller.komposisiNama.text,
                              double.parse(controller.komposisiJumlah.text),
                              controller.komposisiSatuan.text,
                            );
                          }
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Tambah Bahan'),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // List Komposisi
            Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Daftar Komposisi:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.listKomposisi.length,
                  itemBuilder: (context, index) {
                    final bahan = controller.listKomposisi[index];
                    return Card(
                      child: ListTile(
                        title: Text(bahan['nama']),
                        subtitle: Text('${bahan['jumlah']} ${bahan['satuan']}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => controller.hapusKomposisi(index),
                        ),
                      ),
                    );
                  },
                ),
              ],
            )),

            const SizedBox(height: 20),

            // Submit Button
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (controller.namaProduk.text.isNotEmpty &&
                        controller.listKomposisi.isNotEmpty) {
                      controller.addProdukDetail(controller.namaProduk.text);
                    } else {
                      Get.snackbar(
                        'Error',
                        'Nama produk dan minimal satu bahan harus diisi',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text(
                    'Simpan Produk',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/
