import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medi_vault/models/sync_model.dart';

class HiveInitService extends GetxService {
  static init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(SyncModelAdapter());
  }
}