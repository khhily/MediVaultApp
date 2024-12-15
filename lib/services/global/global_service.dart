import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:medi_vault/models/entity/medication_stock_record.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:medi_vault/models/entity/medication_stock.dart';

import 'db/table_create.dart';

part './sqlite.service.dart';
part './http.service.dart';
part './db/medication_stock_access.dart';
part './db/medication_stock_record_access.dart';

class GlobalService {
  GlobalService._();

  static final GlobalService _instance = GlobalService._();

  factory GlobalService() => _instance;

  Future init() async {
    await Get.putAsync(() => SqliteService._().init());
    Get.put(MedicationStockAccess._());
    Get.put(MedicationStockRecordAccess._());

    Get.put(HttpService._());
  }
}