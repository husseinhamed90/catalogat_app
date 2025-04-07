import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/domain/entities/entities.dart';
import 'package:catalogat_app/presentation/blocs/blocs.dart';

class BrandItemWidget extends StatelessWidget {
  final BrandEntity brand;

  const BrandItemWidget({super.key, required this.brand});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, Routes.productsList, arguments: {
          ArgumentsNames.brand: brand,
          ArgumentsNames.brandsCubit: context.read<BrandsCubit>(),
        });
      },
      child: Container(
        width: 112,
        color: Colors.white,
        padding: const EdgeInsets.all(Dimens.medium),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: brand.logoUrl != null
                  ? NetworkImage(brand.logoUrl ?? "")
                  : AssetImage(Assets.images.imgPlaceholder.path),
            ),
            Gap(10),
            Expanded(
              child: Text(
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  brand.name ?? "",
                  style: TextStyle(color: AppColors.textColor, fontWeight: FontWeight.w500, fontSize: FontSize.xSmall)),
            ),
          ],
        ),
      ),
    );
  }
}