import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/presentation/widgets/widgets.dart';

class PrimaryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color? color;
  final String? title;
  final double elevation;
  final bool isCenterTitle;
  final Widget? titleWidget;
  final bool showBackButton;
  final Widget? leadingWidget;
  final List<Widget>? actions;
  final double? leadingWidth;
  final double? appBarHeight;
  final double? titleSpacing;
  final Color? backButtonColor;
  final TextStyle? titleStyle;
  final VoidCallback? onBackButtonPressed;

  const PrimaryAppBar({
    super.key,
    this.title,
    this.color,
    this.actions,
    this.elevation=0,
    this.titleWidget,
    this.titleStyle,
    this.leadingWidth,
    this.titleSpacing,
    this.appBarHeight,
    this.leadingWidget,
    this.backButtonColor,
    this.onBackButtonPressed,
    this.isCenterTitle = true,
    this.showBackButton = true,
  });

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight ?? kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final List<Widget> leadingContent = [];

    if (showBackButton) {
      leadingContent.add(Gap(Dimens.small));
      leadingContent.add(PrimaryBackButton(
        backButtonColor: backButtonColor,
        onBackButtonPressed: onBackButtonPressed,
      ));
    }

    if (leadingWidget != null) {
      leadingContent.add(leadingWidget!);
    }

    final isOnlyLeadingWidget = leadingContent.length == 1 &&  leadingWidget!=null;

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: color ?? Colors.white,
      elevation: elevation,
      leadingWidth:title!=null || titleWidget!=null
          ? leadingWidth
          : double.infinity,
      leading: leadingContent.isNotEmpty ? isOnlyLeadingWidget ? FittedBox(fit: BoxFit.scaleDown,child: leadingWidget) :  Row(children: leadingContent) : null,
      titleSpacing: titleSpacing ?? (isCenterTitle && leadingContent.isEmpty ? 0.0 : NavigationToolbar.kMiddleSpacing),
      centerTitle: isCenterTitle,
      title: title != null ? AutoSizeText(
        title!,
        maxLines: 1,
        style: titleStyle ?? TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: FontSize.xMedium
        ),
      ) : titleWidget,
      actions: actions,
    );
  }
}