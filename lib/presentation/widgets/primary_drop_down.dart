import 'package:catalogat_app/core/dependencies.dart';

class PrimaryDropDown<T> extends StatelessWidget {
  const PrimaryDropDown({super.key, this.selectedItem, required this.items, required this.hintText, this.onChanged, required this.validator, required this.displayValue});

  final T ? selectedItem;
  final List<T> items;
  final String hintText;
  final Function(T?)? onChanged;
  final String? Function(T? value) validator;
  final String Function(T item) displayValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      isExpanded: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      value: selectedItem,
      validator: validator,
      hint: AutoSizeText(hintText, style: TextStyle(color: Colors.grey.shade400),overflow: TextOverflow.ellipsis,),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
              color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
              color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.blue),
        ),
      ),
      items: items.map((item) {
        print(displayValue(item));
        return DropdownMenuItem<T>(
        value: item,
        child: Text(
          overflow: TextOverflow.ellipsis,
          displayValue(item),
        ),
      );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
