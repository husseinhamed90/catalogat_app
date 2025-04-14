import 'package:catalogat_app/core/dependencies.dart';
import 'package:flutter/services.dart';

class AmountInputField extends StatelessWidget {
  final String? label;
  final String hint;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isRequired;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const AmountInputField({
    super.key,
    this.label,
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
        if(label != null && label!.isNotEmpty)...[
          Text(
            label! + (isRequired ? ' *' : ''),
            style: TextStyle(
              fontSize: FontSize.medium,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Gap(Dimens.verticalSemiSmall),
        ],
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          focusNode: focusNode,
          keyboardType: TextInputType.number,
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
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
            LengthLimitingTextInputFormatter(14),
          ],
          validator: validator ?? (value) {
            if (value == null || value.isEmpty) {
              return context.l10n.error_requiredField;
            }
            if (double.tryParse(value) == null) {
              return context.l10n.error_invalidPrice;
            }
            return null;
          },
          onChanged: (v) {
            final String value = v.convertDigitsLangToEnglish;
            controller.value = controller.value.copyWith(text: value);

            ///formatter
            if (value.isNotEmpty && value[0] == '0') controller.text = '';

            ///action callback
            controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
          },
        ),
      ],
    );
  }
}