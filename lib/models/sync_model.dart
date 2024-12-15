import 'package:hive/hive.dart';

part 'sync_model.g.dart';

@HiveType(typeId: 1)
class SyncModel extends HiveObject {
  static const String cacheKey = 'sync_model_cache_key';
  static const String putKey = 'defaultSyncModel';

  @HiveField(0)
  String? syncUrl;

  SyncModel({
    this.syncUrl,
  });
}
