part of '../global_service.dart';

class MedicationStockRecordAccess extends GetxService {
  MedicationStockRecordAccess._();

  final String _tableName = "MedicationStockRecord";

  final SqliteService sqliteService = Get.find<SqliteService>();

  Future<List<MedicationStockRecord>> getList({
    int page = 1,
    int pageSize = 20,
    String? keyword,
  }) async {
    final offset = (page - 1) * pageSize;
    final whereList = <String>[];
    final whereArgs = <Object>[];
    if (keyword != null && keyword.trim().isNotEmpty) {
      whereList.add("MedicationName like ?");
      whereArgs.add('%$keyword%');
    }
    final where =
        whereList.isNotEmpty ? whereList.join(' and ') : null;
    List<Map<String, Object?>> list = await sqliteService.db.query(
      _tableName,
      where: where,
      whereArgs: whereArgs,
      limit: pageSize,
      offset: offset,
      orderBy: 'EntryDate desc',
    );

    return list.map<MedicationStockRecord>((item) => MedicationStockRecord.fromJson(item)).toList();
  }

  Future insert(MedicationStockRecord record) async {
    final map = record.toJson();
    if (map.containsKey('Id')) {
      map.remove('Id');
    }
    await sqliteService.db.insert(_tableName, map);
  }

  Future delete(int id) async {
    const whereSql = "Id = ?";
    final whereArgs = [id];

    await sqliteService.db.delete(_tableName, where: whereSql, whereArgs: whereArgs);
  }

  Future deleteAll(List<int> ids) async {
    final whereSql = "Id in (${List.filled(ids.length, '?').join(',')})";

    await sqliteService.db.delete(_tableName, whereArgs: ids, where: whereSql);
  }
}
