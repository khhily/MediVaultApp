import 'dart:async';

import 'package:hive/hive.dart';

class HiveCacheService {
  HiveCacheService._();

  static final HiveCacheService _instance = HiveCacheService._();

  factory HiveCacheService() => _instance;

  final Map<String, Future> _futureMap = <String, Future>{};

  final Map<String, dynamic> _boxMap = <String, dynamic>{};

  Future<List<T>> getList<T>(String cacheKey, int page, int pageSize) async {
    final box = await getBox<T>(cacheKey);
    print('total data: ${box.values.length}');
    return box.values.skip((page - 1) * pageSize).take(pageSize).toList();
  }

  Future clearAll<T>(String cacheKey) async {
    final box = await getBox<T>(cacheKey);
    await box.clear();
  }

  Future<Box<T>> getBox<T>(String cacheKey) async {
    if (_boxMap.containsKey(cacheKey) && (_boxMap[cacheKey] as Box<T>).isOpen) {
      return _boxMap[cacheKey];
    }

    if (_futureMap.containsKey(cacheKey)) {
      print('Future Map has ${cacheKey}');
      await _futureMap[cacheKey];
    }

    Completer completer = Completer();
    _futureMap.putIfAbsent(cacheKey, () => completer.future);

    try {
      if (Hive.isBoxOpen(cacheKey)) {
        print('Box ${cacheKey} Is Open');
      } else {
        print('Opening box ${cacheKey}');
        final box = await Hive.openBox<T>(cacheKey);

        _boxMap.update(cacheKey, (v) => box, ifAbsent: () => box);
      }

      completer.complete();
    } finally {
      _futureMap.remove(cacheKey);
    }

    return _boxMap[cacheKey];
  }

  Future<List<T>> getAll<T>(String cacheKey) async {
    final box = await getBox<T>(cacheKey);
    return box.values.toList(growable: false);
  }

  Future<T> add<T>(String cacheKey, T obj, {dynamic key}) async {
    final box = await getBox<T>(cacheKey);
    if (key != null) {
      await box.put(key, obj);
      return obj;
    } else {
      await box.add(obj);
      return obj;
    }
  }

  Future clearDatabase() async {
    await Hive.deleteFromDisk();
  }
}
