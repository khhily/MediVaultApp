import 'package:jiffy/jiffy.dart';

abstract class DateHelper {
  static String format(DateTime? dt, {String fmt = 'yyyy-MM-dd HH:mm:ss'}) {
    if (dt == null) return '';
    return Jiffy.parseFromDateTime(dt).format(pattern: fmt);
  }

  static DateTime? parse(
    String dt, {
    String pattern = 'yyyy-MM-dd HH:mm:ss',
    bool toUtc = true,
  }) {
    final jiffy = Jiffy.parse(dt, pattern: pattern);
    if (toUtc) {
      return jiffy.toUtc().dateTime;
    }
    return jiffy.dateTime;
  }
}
