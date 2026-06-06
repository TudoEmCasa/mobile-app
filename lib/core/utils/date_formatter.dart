import 'package:intl/intl.dart';

class DateFormatter {
  const DateFormatter._();

  static String formatDate(DateTime date, {String? locale}) {
    return DateFormat.yMd(locale).format(date.toLocal());
  }
}
