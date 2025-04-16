import 'package:intl/intl.dart';

extension NumberFormattingExtension on num {
  String formatAsCurrency() {
    // Truncate to 2 decimal places
    final truncated = (this * 100).truncateToDouble() / 100;

    // Format with fixed 2 decimal places
    return NumberFormat('#,##0.00', 'en_US').format(truncated);
  }

  String get finalTotal {
    if (isNaN || isInfinite) {
      return " - ";
    } else {
      return formatAsCurrency();
    }
  }
}