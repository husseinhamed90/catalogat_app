import 'package:catalogat_app/core/dependencies.dart';

class PrimaryFloatingActionButton extends StatelessWidget {
  const PrimaryFloatingActionButton({
    super.key,
    required this.onPressed,
    this.icon,
    this.padding,
  });

  final EdgeInsetsGeometry? padding;

  final VoidCallback onPressed;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onPressed,
      child: Container(
          padding: padding ?? EdgeInsets.all(Dimens.horizontalSmall),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon ?? Icon(Icons.add, color: Colors.white, size: Dimens.horizontalLarge,)
            ],
          )
      ),
    );
  }
}