part of 'data_sync.service.dart';

abstract class _SyncBase {
  Future<List<Map<String, Object?>>> _getList({required int page, int pageSize = 20});

  Future _deleteSynced(List<Object> ids) async {}

  List<Object> _getIds(List<Map<String, Object?>> data);

  Future _patch();
}
