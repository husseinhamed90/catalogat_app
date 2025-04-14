import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/domain/entities/entities.dart';
import 'package:catalogat_app/presentation/blocs/blocs.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:catalogat_app/presentation/ui/products/widgets/widgets.dart';

class BrandProductsListWidget extends StatelessWidget {
  final List<BrandEntity> brands;

  const BrandProductsListWidget({super.key, required this.brands});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: brands.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        final brand = brands[index];
        final products = brand.products;
        return Padding(
          padding: EdgeInsets.only(bottom: Dimens.verticalXXLarge),
          child: Container(
            padding: EdgeInsets.only(top: Dimens.verticalMedium),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dimens.horizontalMedium),
                  child: Row(
                    children: [
                      Expanded(child: Text(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          brand.name ?? "",
                          style: TextStyle(color: AppColors.textColor, fontWeight: FontWeight.bold, fontSize: FontSize.xMedium))
                      ),
                      if(products.isNotEmpty)...[
                        Gap(Dimens.horizontalLarge),
                        InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed(Routes.productsList, arguments: {
                                ArgumentsNames.brand: brand,
                                ArgumentsNames.orderCubit: context.read<OrderCubit>(),
                                ArgumentsNames.brandsCubit: context.read<BrandsCubit>(),
                              });
                            },
                            child: Text(context.l10n.action_viewAll, style: TextStyle(color: AppColors.blue, fontWeight: FontWeight.w500, fontSize: FontSize.xSmall))),
                        Gap(7.h),
                        Icon(Icons.arrow_forward_ios, color: AppColors.blue, size: Dimens.verticalXSmall),
                      ]
                    ],
                  ),
                ),
                Gap(Dimens.verticalSemiSmall),
                Builder(builder: (context) {
                  if(products.isNotEmpty) {
                    return SizedBox(
                      height: 330.h,
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(horizontal: Dimens.horizontalSemiSmall),
                        scrollDirection: Axis.horizontal,
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final item = products[index];
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ProductItemWidget(
                                item: item,
                                orderCubit: context.read<OrderCubit>(),
                              ),
                              if(index != products.length - 1) Gap(4.w),
                            ],
                          );
                        },
                      ),
                    );
                  }
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(Routes.addProduct,arguments: {
                        ArgumentsNames.brandsCubit: context.read<BrandsCubit>(),
                      });
                    },
                    child: Container(
                      height: 150.h,
                      width: double.infinity,
                      padding: EdgeInsets.all(Dimens.verticalMedium),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              Assets.icons.icProduct,
                              width: 50.w,
                              height: 50.h,
                            ),
                            Gap(Dimens.verticalSmall),
                            Text(context.l10n.empty_product_list, style: TextStyle(color: AppColors.textColor, fontWeight: FontWeight.w500, fontSize: FontSize.medium)),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}