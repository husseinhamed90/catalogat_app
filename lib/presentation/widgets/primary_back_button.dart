import 'package:catalogat_app/core/dependencies.dart';

class PrimaryBackButton extends StatelessWidget {
  const PrimaryBackButton({super.key, this.onBackButtonPressed, this.backButtonColor});

  final VoidCallback? onBackButtonPressed;
  final Color? backButtonColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: onBackButtonPressed ?? () => Navigator.of(context).pop(),
      child: SvgPicture.asset(
        Assets.icons.icLeftArrow,
        color: backButtonColor,
        height: 24,
        width: 24,
      ),
    );
  }
}
