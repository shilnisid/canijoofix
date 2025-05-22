import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/reset_pass/bindings/reset_pass_binding.dart';
import '../modules/login/reset_pass/views/reset_pass_view.dart';
import '../modules/login/views/login_view.dart';
import '../modules/add_produk_detail/bindings/add_produk_detail_binding.dart';
import '../modules/add_produk_detail/views/add_produk_detail_view.dart';
import '../modules/addbahan_baku/bindings/addbahan_baku_binding.dart';
import '../modules/addbahan_baku/views/addbahan_baku_view.dart';
import '../modules/addsupplier/bindings/addsupplier_binding.dart';
import '../modules/addsupplier/views/addsupplier_view.dart';
import '../modules/bahan_baku/bindings/bahan_baku_binding.dart';
import '../modules/bahan_baku/views/bahan_baku_view.dart';
import '../modules/editBahan_baku/bindings/edit_bahan_baku_binding.dart';
import '../modules/editBahan_baku/views/edit_bahan_baku_view.dart';
import '../modules/editSupplier/bindings/edit_supplier_binding.dart';
import '../modules/editSupplier/views/edit_supplier_view.dart';
import '../modules/navbar/bindings/navbar_binding.dart';
import '../modules/navbar/views/navbar_view.dart';
import '../modules/produk_detail/bindings/produk_detail_binding.dart';
import '../modules/produk_detail/views/produk_detail_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/signup/bindings/signup_binding.dart';
import '../modules/signup/views/signup_view.dart';
import '../modules/supplier/bindings/supplier_binding.dart';
import '../modules/supplier/views/supplier_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
      children: [
        GetPage(
          name: _Paths.RESET_PASS,
          page: () => ResetPasswordView(),
          binding: ResetPassBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => const SignupView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: _Paths.BAHAN_BAKU,
      page: () => const BahanBakuView(),
      binding: BahanBakuBinding(),
    ),
    GetPage(
      name: _Paths.SUPPLIER,
      page: () => const SupplierView(),
      binding: SupplierBinding(),
    ),
    GetPage(
      name: _Paths.NAVBAR,
      page: () => NavbarView(),
      binding: NavbarBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.ADDBAHAN_BAKU,
      page: () => AddbahanBakuView(),
      binding: AddbahanBakuBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_BAHAN_BAKU,
      page: () => EditBahanBakuView(),
      binding: EditBahanBakuBinding(),
    ),
    GetPage(
      name: _Paths.ADD_PRODUK_DETAIL,
      page: () => const AddProdukDetailView(),
      binding: AddProdukDetailBinding(),
    ),
    GetPage(
      name: _Paths.PRODUK_DETAIL,
      page: () => ProdukDetailView(),
      binding: ProdukDetailBinding(),
    ),
    GetPage(
      name: _Paths.ADDSUPPLIER,
      page: () => const AddsupplierView(),
      binding: AddsupplierBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_SUPPLIER,
      page: () => const EditSupplierView(),
      binding: EditSupplierBinding(),
    ),

  ];
}
