part of '../global_service.dart';

class MedicationStockAccess extends GetxService {
  MedicationStockAccess._();

  final String _tableName = "MedicationStock";

  final SqliteService sqliteService = Get.find<SqliteService>();

  Future<List<MedicationStock>> getPage({
    required int page,
    int pageSize = 20,
    String? keyword,
  }) async {
    final whereSqlList = <String>[];
    final args = <Object?>[];

    if (keyword != null && keyword.isNotEmpty) {
      whereSqlList.add("MedicationName like ?");
      args.add('%$keyword%');
    }

    final whereSql =
        whereSqlList.isNotEmpty ? whereSqlList.join(' and ') : null;

    final list = await sqliteService.db.query(
      _tableName,
      where: whereSql,
      whereArgs: args,
      orderBy: "UpdateTime DESC",
      limit: pageSize,
      offset: (page - 1) * pageSize,
    );

    return list
        .map<MedicationStock>((item) => MedicationStock.fromJson(item))
        .toList();
  }

  Future<List<MedicationStock>> getAll() async {
    final list = await sqliteService.db.query(
      _tableName,
      orderBy: "MedicationName ASC",
    );

    return list
        .map<MedicationStock>((item) => MedicationStock.fromJson(item))
        .toList();
  }

  Future<MedicationStock?> getByName(String name) async {
    final result = await sqliteService.db.query(_tableName,
        where: 'MedicationName = ?', whereArgs: [name], limit: 1);

    if (result.isNotEmpty) return MedicationStock.fromJson(result.first);

    return null;
  }

  Future insert(MedicationStock stock) async {
    await sqliteService.db.insert(_tableName, stock.toJson());
  }

  Future insertOrUpdate(MedicationStock stock) async {
    await sqliteService.db.transaction((trans) async {
      final old = await trans.query(_tableName,
          limit: 1,
          where: 'MedicationName = ?',
          whereArgs: [stock.medicationName]);
      if (old.isNotEmpty) {
        await trans.update(_tableName, stock.toJson());
      } else {
        await trans.insert(_tableName, stock.toJson());
      }
    });
  }

  Future update(MedicationStock stock) async {
    await sqliteService.db.rawUpdate(
      'update $_tableName set StockQuantity = ?, Unit = ?, AveragePrice = ?, UpdateTime = CURRENT_TIMESTAMP where MedicationName = ?',
      [
        stock.stockQuantity,
        stock.unit,
        stock.averagePrice,
        stock.medicationName
      ],
    );
  }

  Future delete(String name) async {
    await sqliteService.db.delete(
      _tableName,
      where: 'MedicationName = ?',
      whereArgs: [name],
    );
  }

  Future batchInsertOrUpdate(List<MedicationStock> data) async {
    final Batch batch = sqliteService.db.batch();

    for (final item in data) {
      batch.insert(_tableName, item.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }

    await batch.commit(noResult: true);
  }

  Future patchUpdateByRecords(List<MedicationStockRecord> records) async {
    final batch = sqliteService.db.batch();

    for (final record in records) {
      if (record.operation == MedicationStockOperation.increment) {
        batch.rawUpdate(
          'update $_tableName set StockQuantity = StockQuantity + ?, AveragePrice = ((StockQuantity * AveragePrice + ?) / (StockQuantity + ?)) where MedicationName = ?',
          [
            record.quantity,
            record.totalPrice,
            record.quantity,
            record.medicationName
          ],
        );
      } else {
        batch.rawUpdate(
          'update $_tableName set StockQuantity = StockQuantity + ? where MedicationName = ?',
          [record.quantity, record.medicationName],
        );
      }
    }

    await batch.commit(noResult: true);
  }
}
