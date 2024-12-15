import 'package:get/get.dart';
import 'package:medi_vault/pages/history/history_page.controller.dart';
import 'package:medi_vault/pages/history/history_page.dart';
import 'package:medi_vault/pages/home/home_page.controller.dart';
import 'package:medi_vault/pages/home/home_page.dart';
import 'package:medi_vault/pages/medication_stock/add_medication_stock_page.controller.dart';
import 'package:medi_vault/pages/medication_stock/add_medication_stock_page.dart';
import 'package:medi_vault/pages/setting/setting_page.controller.dart';
import 'package:medi_vault/pages/setting/setting_page.dart';

List<GetPage<dynamic>> routes = [
  GetPage(
    name: '/',
    page: () => const HomePage(),
    binding: BindingsBuilder(
      () {
        Get.put(HomePageController());
      },
    ),
  ),
  GetPage(
    name: '/add-medication-stock',
    page: () => const AddMedicationStockPage(),
    binding: BindingsBuilder(() {
      Get.put(AddMedicationStockPageController());
    }),
  ),
  GetPage(
    name: '/history',
    page: () => const HistoryPage(),
    binding: BindingsBuilder(() {
      Get.put(HistoryPageController());
    }),
  ),
  GetPage(
    name: '/setting',
    page: () => const SettingPage(),
    binding: BindingsBuilder(() {
      Get.put(SettingPageController());
    }),
  ),
];
