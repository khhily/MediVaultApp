part of 'data_sync.service.dart';

class _SyncBase {
  Future<List<Map<String, Object?>>> _getList({required int page}) async {
    return [];
  }

  Future _deleteSynced(List<Object> ids) async {}

  List<Object> _getIds(List<Map<String, Object?>> data) {
    return [];
  }

  Future _patch() async {}
}
