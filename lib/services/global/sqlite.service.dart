part of './global_service.dart';

class SqliteService extends GetxService {
  SqliteService._();

  Database? _db;

  Database get db => _db!;

  Future<SqliteService> init([int? userId]) async {
    if (_db != null) {
      await _db!.close();
    }

    final databasePath = await getDatabasesPath();
    final fileName = userId == null ? 'default.db' : '$userId.db';
    String path = join(databasePath, fileName);

    // await deleteDatabase(path);

    _db = await openDatabase(path, version: 1, onCreate: (db, i) async {
      await db.execute(medicationStockTableCreateSql);
      await db.execute(medicationStockRecordsTableCreateSql);
    });

    return this;
  }
}
