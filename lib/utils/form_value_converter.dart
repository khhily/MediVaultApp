abstract class FormValueConverter {
  static double? stringToDouble(String v) {
    final result = v.trim().isEmpty ? null : double.tryParse(v);
    print('stringToDouble: $v = $result');
    return result;
  }
  static String doubleToString(double? v) => v == null ? '' : '$v';

  static int? stringToInt(String v) => v.trim().isEmpty ? null : int.tryParse(v);
  static String intToString(int? v) => v == null ? '' : '$v';
}