import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medi_vault/models/enum/medication_stock_operation.dart';

class MedicationStockBottomSheetMenus extends StatelessWidget {
  const MedicationStockBottomSheetMenus({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          tileColor: Colors.grey[200],
          leading: const Icon(Icons.input),
          title: const Text('入库'),
          onTap: () {
            Get.back(result: MedicationStockOperation.increment);
          },
        ),
        ListTile(
          tileColor: Colors.grey[200],
          leading: const Icon(Icons.output),
          title: const Text('出库'),
          onTap: () {
            Get.back(result: MedicationStockOperation.decrement);
          },
        ),
      ],
    );
  }
}
