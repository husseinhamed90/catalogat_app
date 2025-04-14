import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  // 12 May 2023
  String get formattedDate {
    return DateFormat('d MMM yyyy','ar_EG').format(this);
  }
}