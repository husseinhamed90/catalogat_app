import 'package:catalogat_app/core/dependencies.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({super.key, required this.title, this.onPressed, this.isLoading = false});

  final String title;
  final bool isLoading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
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
            return Text(
                title,
                style: TextStyle(fontSize: FontSize.medium, color: Colors.white)
            );
          }
      ),
    );
  }
}
