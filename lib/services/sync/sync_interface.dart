part of 'data_sync.service.dart';

abstract class _SyncInterface {
  Future<List<Map<String, Object?>>> _getList({required int page});

  Future _deleteSynced(List<Object> ids) async {}

  List<Object> _getIds(List<Map<String, Object?>> data);

  Future _patch();
}
