import 'package:catalogat_app/core/dependencies.dart';

class PrimaryBackButton extends StatefulWidget {
  const PrimaryBackButton({super.key, this.onBackButtonPressed, this.backButtonColor});

  final VoidCallback? onBackButtonPressed;
  final Color? backButtonColor;

  @override
  State<PrimaryBackButton> createState() => _PrimaryBackButtonState();
}

class _PrimaryBackButtonState extends State<PrimaryBackButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: widget.onBackButtonPressed ?? () {
        if (context.mounted) Navigator.of(context).pop();
      },
      child: SvgPicture.asset(
        Assets.icons.icLeftArrow,
        color: widget.backButtonColor,
        height: 24,
        width: 24,
      ),
    );
  }
}
