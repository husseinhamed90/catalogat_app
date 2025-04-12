import 'package:catalogat_app/core/dependencies.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({super.key, required this.title, this.onPressed, this.isLoading = false, this.backgroundColor, this.textColor, this.borderColor, this.iconPath, this.elevation, this.isEnabled = true});

  final String title;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final bool isLoading;
  final bool isEnabled;
  final VoidCallback? onPressed;
  final String? iconPath;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: elevation,
        backgroundColor: isEnabled ? (backgroundColor ?? Colors.black) : Colors.grey.shade300,
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: isEnabled ? (borderColor ?? Colors.black) : Colors.grey.shade300,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      onPressed: onPressed,
      child: Builder(
          builder: (context) {
            if (isLoading) {
              return CircularProgressIndicator(
                color: Colors.white,
              );
            }
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (iconPath != null && iconPath!.isNotEmpty)...[
                  SvgPicture.asset(
                    iconPath ?? '',
                    width: 24,
                    height: 24,
                  ),
                  Gap(Dimens.horizontalSemiSmall),
                ],
                Text(
                    title,
                    style: TextStyle(fontSize: FontSize.medium, color: textColor ?? Colors.white)
                ),
              ],
            );
          }
      ),
    );
  }
}
