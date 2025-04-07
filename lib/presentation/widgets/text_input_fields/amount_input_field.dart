import 'package:catalogat_app/core/dependencies.dart';
import 'package:flutter/services.dart';

class AmountInputField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isRequired;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const AmountInputField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.isRequired = false,
    required this.focusNode,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label + (isRequired ? ' *' : ''),
          style: TextStyle(
            fontSize: FontSize.medium,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        Gap(Dimens.semiSmall),
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          focusNode: focusNode,

          keyboardType: TextInputType.number,
          controller: controller,
          decoration: InputDecoration(
            hintText: "Enter product price",
            hintStyle: TextStyle(color: Colors.grey.shade400),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColors.blue),
            ),
          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[\u0660-\u06690-9]')),
            LengthLimitingTextInputFormatter(14),
          ],
          validator: validator,
          onChanged: (v) {
            final String value = v.convertDigitsLangToEnglish;
            controller.value = controller.value.copyWith(text: value);

            ///formatter
            if (value.isNotEmpty && value[0] == '0') controller.text = '';
            controller.text = controller.text.amountFormatter;

            ///action callback
            controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
          },
        ),
      ],
    );
  }
}