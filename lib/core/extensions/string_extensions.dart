extension StringExtension on String {
  String get convertDigitsLangToEnglish {
    String input = this;
    const int mode = 1;
    final List<String> arabicNumbers =<String> [
      '٠',
      '١',
      '٢',
      '٣',
      '٤',
      '٥',
      '٦',
      '٧',
      '٨',
      '٩'
    ];
    final RegExp regex = RegExp(<String>['[0-9]', '[٠-٩]'][mode]);
    final Set<String> matches = Set<String>.from(
        regex.allMatches(input).map((RegExpMatch e) => e.group(0).toString()));
    String replacement(String match) => arabicNumbers.indexOf(match).toString();
    for (final match in matches) {
      input = input.replaceAll(match, replacement(match));
    }
    return input;
  }

  String get amountFormatter {
    final price = replaceAll(',', '');
    String priceInText = "";
    int counter = 0;
    for(int i = price.length - 1;  i >= 0; i--){
      counter++;
      final String str = price[i];
      if((counter % 3) != 0 && i !=0){
        priceInText = "$str$priceInText";
      }else if(i == 0 ){
        priceInText = "$str$priceInText";

      }else{
        priceInText = ",$str$priceInText";
      }
    }
    return priceInText.trim();
  }

  String get removeNonNumber => toString().replaceAll(RegExp(r"\D"), "");
}