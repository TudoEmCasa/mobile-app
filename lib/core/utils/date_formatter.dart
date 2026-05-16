import 'package:intl/intl.dart';

class DateFormatter {
  const DateFormatter._();

  static String formatDate(DateTime date) {
    return DateFormat.yMd().format(date.toLocal());
  }
}
