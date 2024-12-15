import 'dart:async';

import 'package:hive/hive.dart';
import 'package:medi_vault/services/hive_cache.service.dart';

class DataCacheService {
  DataCacheService._();

  static final DataCacheService _instance = DataCacheService._();

  factory DataCacheService() => _instance;

  final cache = HiveCacheService();

  Future<List<T>> getList<T>(String name, int page, int pageSize) async {
    final list = await cache.getList<T>(name, page, pageSize);
    return list;
  }

  Future<List<T>> getAll<T>(String cacheKey) async {
    final list = await cache.getAll<T>(cacheKey);
    return list;
  }

  Future<T?> find<T>(String cacheKey,
      {dynamic key, bool Function(T)? predicator}) async {
    final box = await cache.getBox<T>(cacheKey);

    if (key != null) {
      return box.get(key);
    } else if (predicator != null) {
      return box.values.firstWhere(predicator);
    }

    return null;
  }

  Future update<T>(
    String cacheKey, {
    dynamic key,
    FutureOr<T> Function(T)? updater,
    T Function()? ifAbsent,
  }) async {
    final box = await cache.getBox<T>(cacheKey);
    if(box.containsKey(key)) {
      T item = box.get(key) as T;
      if (updater != null) {
        item = await updater.call(item);
      }
      await box.put(key, item);
    } else {
      T? item;
      if (ifAbsent != null) item = ifAbsent();
      await box.put(key, item as T);
    }
  }

  Future delete<T>(
      {required String cacheKey, required bool Function(T) predicator}) async {
    final box = await HiveCacheService().getBox<T>(cacheKey);
    final futureList = box.keys
        .where((k) => predicator(box.get(k) as T))
        .map<Future>((k) => box.delete(k))
        .toList(growable: false);
    await Future.wait(futureList);
  }
}
