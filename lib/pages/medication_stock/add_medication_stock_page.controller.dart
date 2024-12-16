import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medi_vault/models/entity/medication_stock.dart';
import 'package:medi_vault/models/entity/medication_stock_record.dart';
import 'package:medi_vault/models/enum/medication_stock_operation.dart';
import 'package:medi_vault/services/global/global_service.dart';
import 'package:medi_vault/services/sync/data_sync.service.dart';

class AddMedicationStockPageController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final operationType = MedicationStockOperation.increment.obs;
  final name = ''.obs;
  final count = RxnDouble();
  final unit = 'g'.obs;
  final nameReadonly = false.obs;
  final totalPrice = RxnDouble();

  final msAccess = Get.find<MedicationStockAccess>();
  final msrAccess = Get.find<MedicationStockRecordAccess>();
  final dataSync = DataSyncService();

  @override
  void onInit() {
    if (Get.arguments != null) {
      if (Get.arguments['operationType'] != null) {
        operationType.value = Get.arguments['operationType'];
      }
      if (Get.arguments['exist'] != null) {
        nameReadonly.value = true;
      }
      if (Get.arguments['item'] != null) {
        final item = Get.arguments['item'] as MedicationStock;
        name.value = item.medicationName;
        unit.value = item.unit;
      }
    }
    super.onInit();
  }

  void saveAndClose(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      double count = this.count.value!;

      final isDecrement =
          operationType.value == MedicationStockOperation.decrement;

      if (isDecrement) {
        count = -count;
      }

      MedicationStock stock = (await msAccess.getByName(name.value)) ??
          MedicationStock(
            medicationName: name.value,
            stockQuantity: 0,
            unit: unit.value,
            averagePrice: 0,
            updateTime: DateTime.now().toUtc(),
          );

      if (!isDecrement) {
        stock.averagePrice =
            (stock.averagePrice * stock.stockQuantity + totalPrice.value!) /
                (stock.stockQuantity + count);
      }

      stock.stockQuantity += count;
      stock.unit = unit.value;

      stock.updateTime = DateTime.now().toUtc();

      await msAccess.insertOrUpdate(stock);

      // 记录操作
      final record = MedicationStockRecord(
        medicationName: name.value,
        quantity: count,
        entryDate: DateTime.now().toUtc(),
        id: 0,
        operation: operationType.value,
      );

      if (!isDecrement) {
        record.unitPrice = totalPrice.value! / this.count.value!;
        record.totalPrice = totalPrice.value;
      }

      await msrAccess.insert(record);

      await dataSync.syncData();

      Get.back(result: {
        'name': name,
        'count': count,
      });
    }
  }
}
