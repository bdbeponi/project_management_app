import 'package:intl/intl.dart';

class DateTimeUtil {
  const DateTimeUtil._(); // prevent instantiation

  static String formatDateRange(DateTime? startDate, DateTime? endDate) {
    if (startDate == null || endDate == null) return '';

    final startDay = DateFormat('d').format(startDate);
    final startMonth = DateFormat('MMM').format(startDate); // e.g. Jul
    final endDay = DateFormat('d').format(endDate);
    final endMonth = DateFormat('MMM').format(endDate);
    final year = DateFormat('y').format(endDate);

    // If both dates are in the same month/year → simplify format
    if (startDate.year == endDate.year && startDate.month == endDate.month) {
      return "$startDay - $endDay, $endMonth $year";
    }

    return "$startDay, $startMonth - $endDay, $endMonth $year";
  }

  static String formatDate(DateTime date) {
    DateFormat format = DateFormat("dd MMM yy");
    return format.format(date);
  }
}
