class MedicationStock {
  final String medicationName;

  double stockQuantity;

  String unit;

  double averagePrice;

  DateTime updateTime;

  MedicationStock({
    required this.medicationName,
    this.stockQuantity = 0,
    this.unit = "g",
    this.averagePrice = 0,
    required this.updateTime,
  });

  factory MedicationStock.fromJson(Map<String, dynamic> map) {
    return MedicationStock(
      medicationName: map['MedicationName'] as String,
      unit: map['Unit'] as String,
      stockQuantity: (map['StockQuantity'] as num).toDouble(),
      averagePrice: (map['AveragePrice'] as num).toDouble(),
      updateTime: DateTime.fromMillisecondsSinceEpoch(
        (map['UpdateTime'] as num).toInt(),
        isUtc: true,
      ).toLocal(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "medicationName": medicationName,
      "unit": unit,
      "stockQuantity": stockQuantity,
      "averagePrice": averagePrice,
      "updateTime": updateTime.millisecondsSinceEpoch,
    };
  }
}
