import 'package:catalogat_app/core/dependencies.dart';

class TextInputField extends StatelessWidget {
  final String? label;
  final String hint;
  final int? maxLines;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isRequired;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const TextInputField({
    super.key,
    this.maxLines,
    this.label,
    required this.focusNode,
    required this.hint,
    required this.controller,
    this.isRequired = false,
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
          maxLines: maxLines,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          focusNode: focusNode,
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
          validator: validator,
          onChanged: onChanged,
        ),
      ],
    );
  }
}