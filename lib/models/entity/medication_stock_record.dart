import 'package:medi_vault/models/enum/medication_stock_operation.dart';
import 'package:medi_vault/utils/enum_extensions.dart';

class MedicationStockRecord {
  final int id;

  final String medicationName;

  final MedicationStockOperation operation;

  final double quantity;

  double? unitPrice;

  double? totalPrice;

  final DateTime entryDate;

  bool synced;

  MedicationStockRecord({
    required this.id,
    required this.medicationName,
    required this.quantity,
    this.unitPrice,
    this.totalPrice,
    required this.entryDate,
    required this.operation,
    this.synced = false,
  });

  factory MedicationStockRecord.fromJson(Map<String, Object?> map) {
    return MedicationStockRecord(
      id: map['Id'] as int,
      medicationName: map['MedicationName'] as String,
      quantity: map['Quantity'] as double,
      unitPrice: map['UnitPrice'] as double?,
      totalPrice: map['TotalPrice'] as double?,
      entryDate: DateTime.fromMillisecondsSinceEpoch(
        (map['EntryDate'] as num).toInt(),
        isUtc: true,
      ).toLocal(),
      operation: indexToEnum(
          MedicationStockOperation.values, map['Operation'] as int)!,
      synced: map['Synced'] == 0 ? false : true,
    );
  }

  Map<String, Object?> toJson() {
    return {
      "Id": id,
      "MedicationName": medicationName,
      "Quantity": quantity,
      "UnitPrice": unitPrice,
      "TotalPrice": totalPrice,
      "EntryDate": entryDate.millisecondsSinceEpoch,
      'Operation': operation.index,
      "Synced": synced ? 1 : 0,
    };
  }
}
