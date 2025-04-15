import 'package:intl/intl.dart';

extension NumberFormattingExtension on num {
  String formatAsCurrency() {
    // Convert the number to a string to analyze its decimal part
    final String stringValue = toString();

    // Check if the number has a decimal part
    final bool hasDecimal = stringValue.contains('.');

    if (!hasDecimal || this == roundToDouble()) {
      // Format as integer if no decimal or decimal is all zeros
      return NumberFormat('#,##0', 'en_US').format(this);
    } else {
      // Count significant decimal digits
      final decimalDigits = stringValue.split('.')[1].replaceAll(RegExp(r'0*$'), '').length;

      // Create formatter with exactly the needed decimal places
      final pattern = '#,##0.${'#' * decimalDigits}';
      return NumberFormat(pattern, 'en_US').format(this);
    }
  }

  String get finalTotal {
    if (isNaN || isInfinite) {
      return " - ";
    } else {
      return formatAsCurrency();
    }
  }
}