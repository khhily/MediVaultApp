part of './data_sync.service.dart';

class _MedicationStockRecordSyncService implements _SyncBase {
  final MedicationStockRecordAccess recordAccessor =
      Get.find<MedicationStockRecordAccess>();

  final MedicationStockAccess msAccess = Get.find<MedicationStockAccess>();

  final HttpService http = HttpService();

  @override
  Future _deleteSynced(List<Object> ids) async {
    final idList = ids.map<int>((id) => (id as num).toInt()).toList();
    await recordAccessor.updateSynced(idList, true);
  }

  @override
  Future<List<Map<String, Object?>>> _getList(
      {required int page, int pageSize = 20}) async {
    final list = await recordAccessor.getList(page: page, pageSize: pageSize, synced: false);
    return list.map<Map<String, Object?>>((item) => item.toJson()).toList();
  }

  @override
  Future _patch() async {
    final list =
        await http.http.get<List<dynamic>>('/api/medicationStock/latest');
    final data = list.data
        ?.map<MedicationStock>((item) => MedicationStock.fromJson(item))
        .toList();

    if (data == null) return;

    await msAccess.batchInsertOrUpdate(data);

    final records = await recordAccessor.getAllList(synced: false);

    if (records.isNotEmpty) {
      await msAccess.patchUpdateByRecords(records);
    }
  }

  @override
  List<Object> _getIds(List<Map<String, Object?>> data) {
    return data
        .map<Object>((item) => MedicationStockRecord.fromJson(item).id)
        .toList();
  }
}
