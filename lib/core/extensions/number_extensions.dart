import 'package:intl/intl.dart';

extension NumberFormattingExtension on num {
  String formatAsCurrency() {

    final NumberFormat formatterWithoutDecimal = NumberFormat('#,##0', 'en_US');

    // Convert num to a string with up to two decimal places without rounding beyond the second decimal place
    final String stringWithUpToTwoDecimals = _truncateToTwoDecimalsWithoutRounding(this);

    // Parse the string back to a double for formatting
    final num formattedNumber = num.parse(stringWithUpToTwoDecimals);

    // Determine if the formatted number is an integer (no decimal part) or not
    if (formattedNumber is int || formattedNumber == formattedNumber.roundToDouble()) {
      return formatterWithoutDecimal.format(formattedNumber);
    } else {
      // Use dynamic formatter for numbers with decimal part
      final NumberFormat formatterWithDecimal = NumberFormat('#,##0.##', 'en_US');
      return formatterWithDecimal.format(formattedNumber);
    }
  }

  String get finalTotal {
    if(isNaN || isInfinite) {
      return " - ";
    } else {
      return formatAsCurrency();
    }
  }

  String _truncateToTwoDecimalsWithoutRounding(num value) {
    final String stringValue = value.toString();
    final int dotIndex = stringValue.indexOf('.');
    if (dotIndex != -1) {
      final int end = dotIndex + 3; // Keep one decimal point and up to two decimal places
      if (stringValue.length > end + 1) { // Check if there's a need to truncate
        return stringValue.substring(0, end);
      }
    }
    // Return original string if it doesn't have more than two decimal places
    return stringValue;
  }

}
