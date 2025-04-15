import 'package:catalogat_app/core/dependencies.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrimaryAddItemWidget extends StatelessWidget {
  const PrimaryAddItemWidget({
    super.key,
    required this.onTap, this.text, this.icon,
  });

  final VoidCallback onTap;
  final String? text;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsetsDirectional.only(start: Dimens.horizontalMedium),
        color: Colors.white,
        child: Column(
          children: [
            Center(
              child: DottedBorder(
                padding: EdgeInsets.zero,
                borderType: BorderType.Circle,
                dashPattern: [6, 3],
                color: Colors.grey,
                child: CircleAvatar(
                  radius: 32.r,
                  backgroundColor: Colors.transparent,
                  child: icon ?? Icon(Icons.add, color: Colors.grey, size: 30),
                ),
              ),
            ),
            if(text != null && text!.isNotEmpty) ...[
              Gap(10.h),
              AutoSizeText(text!, style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: FontSize.xSmall)),
            ],
          ],
        ),
      ),
    );
  }
}
