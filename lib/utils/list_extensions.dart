extension ListExtensions<TKey, TValue> on List<TValue> {
  Map<TKey, TValue> toMap(TKey Function(TValue) getKey) {
    return {for (var item in this) getKey(item): item};
  }
}
