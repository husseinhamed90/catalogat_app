import 'package:catalogat_app/core/dependencies.dart';

class PrimaryScaffold extends StatelessWidget {
  final Widget body;
  final Color? backgroundColor;
  final Widget? bottomNavigationBar;
  final bool extendBodyBehindAppBar;
  final Widget? floatingActionButton;
  final bool resizeToAvoidBottomInset;
  final PreferredSizeWidget? appBar;

  const PrimaryScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.backgroundColor,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.resizeToAvoidBottomInset = true,
    this.extendBodyBehindAppBar = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: body,
        appBar: appBar,
        backgroundColor: backgroundColor,
        bottomNavigationBar: bottomNavigationBar,
        floatingActionButton: floatingActionButton,
        extendBodyBehindAppBar: extendBodyBehindAppBar,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      ),
    );
  }
}