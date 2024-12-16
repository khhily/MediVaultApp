part of 'data_sync.service.dart';

class _SyncBase implements _SyncInterface {
  @override
  Future<List<Map<String, Object?>>> _getList({required int page}) async {
    return [];
  }

  @override
  Future _deleteSynced(List<Object> ids) async {}

  @override
  List<Object> _getIds(List<Map<String, Object?>> data) {
    return [];
  }

  @override
  Future _patch() async {}
}
