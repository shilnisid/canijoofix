import '../../..//modules/bahan_baku/views/bahan_baku_view.dart';
import '../../..//modules/home/views/home_view.dart';
import '../../..//modules/profile/views/profile_view.dart';
import '../../..//modules/supplier/views/supplier_view.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class NavbarController extends GetxController {
 
  var currentPageIndex = 0;
  // void loadData() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.getString(controller.emailC.text);
  //   prefs.getString(controller.passC.text);
  // }
  final List<Widget> menuBar = [
    HomeView(),
    const BahanBakuView(),
    const SupplierView(),
    const ProfileView(),
  ];

  void currentPage(int index) async {
    currentPageIndex = index;
    update();
  }
  
}
