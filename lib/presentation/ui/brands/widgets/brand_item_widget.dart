import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/domain/entities/entities.dart';
import 'package:catalogat_app/presentation/blocs/blocs.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BrandItemWidget extends StatelessWidget {
  final BrandEntity brand;
  final bool isLastItem;

  const BrandItemWidget({super.key, required this.brand, required this.isLastItem});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, Routes.productsList, arguments: {
          ArgumentsNames.brand: brand,
          ArgumentsNames.brandsCubit: context.read<BrandsCubit>(),
        });
      },
      child: Padding(
        padding: EdgeInsetsDirectional.only(
            start: Dimens.horizontalMedium,
            end: isLastItem ? Dimens.horizontalMedium : 0,
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40.r,
              backgroundImage: brand.logoUrl != null
                  ? NetworkImage(brand.logoUrl ?? "")
                  : AssetImage(Assets.images.imgPlaceholder.path),
            ),
            Gap(10.h),
            Expanded(
              child: Text(
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  brand.name ?? "",
                  style: TextStyle(color: AppColors.textColor, fontWeight: FontWeight.w500, fontSize: FontSize.xSmall)
              ),
            ),
          ],
        ),
      ),
    );
  }
}