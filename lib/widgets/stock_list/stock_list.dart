import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medi_vault/models/entity/medication_stock.dart';
import 'package:medi_vault/widgets/stock_list/stock_item.dart';

class MedicationStockList extends StatelessWidget {
  final RxList<MedicationStock> items;
  final void Function(MedicationStock)? onTap;
  final void Function(MedicationStock)? onLongTap;

  const MedicationStockList({
    super.key,
    required this.items,
    this.onTap,
    this.onLongTap,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.separated(
        separatorBuilder: (ctx, index) {
          return Container(
            height: 1,
            width: Get.width,
            decoration: const BoxDecoration(
              color: Colors.black12,
            ),
          );
        },
        itemBuilder: (ctx, index) {
          final item = items[index];

          return MedicationStockListItem(
            item: item,
            onTap: onLongTap == null
                ? null
                : () {
                    onLongTap?.call(item);
                  },
          );
        },
        itemCount: items.length,
      ),
    );
  }
}
