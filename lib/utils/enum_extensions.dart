T? indexToEnum<T>(List<T> values, int index) {
  if (index < values.length) {
    return values[index];
  }
  return null;
}
