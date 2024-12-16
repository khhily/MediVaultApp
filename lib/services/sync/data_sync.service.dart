import 'package:get/get.dart';
import 'package:medi_vault/models/entity/medication_stock.dart';
import 'package:medi_vault/models/entity/medication_stock_record.dart';
import 'package:medi_vault/models/sync_model.dart';
import 'package:medi_vault/services/data_cache.service.dart';

import '../global/global_service.dart';

part 'medication_stock_record.sync.dart';

part 'sync_base.dart';
part 'sync_interface.dart';

class DataSyncService {
  DataSyncService._();

  static DataSyncService? _instance;

  factory DataSyncService() => _instance ??= DataSyncService._();

  final DataCacheService dataAccess = DataCacheService();
  final HttpService http = HttpService();

  final List<_SyncBase> _syncServices = [_MedicationStockRecordSyncService()];

  Future syncData() async {
    final config = await dataAccess.find<SyncModel>(SyncModel.cacheKey,
        key: SyncModel.putKey);

    if (config == null ||
        config.syncUrl == null ||
        config.syncUrl!.isEmpty ||
        config.syncUrl!.trim().isEmpty) return;

    for (final s in _syncServices) {
      try {
        await _sync(s);
      } catch (e) {
        //
      }
    }
  }

  Future _sync(_SyncBase service) async {
    int page = 1;
    bool hasMore = true;
    do {
      final list = await service._getList(page: page);
      hasMore = list.length >= 20;

      final ids = service._getIds(list);
      await service._deleteSynced(ids);
    } while (hasMore);

    await service._patch();
  }
}
