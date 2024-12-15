import 'package:intl/intl.dart';

class NumberUtils {
  /// 格式化数字为包含千分位并保留指定小数位数的字符串
  static String formatNumber(num number, {int decimalPlaces = 2}) {
    // 保留指定的小数位数
    final formatString = '#,##0.${'0' * decimalPlaces}';
    final formatter = NumberFormat(formatString);
    return formatter.format(number);
  }
}
