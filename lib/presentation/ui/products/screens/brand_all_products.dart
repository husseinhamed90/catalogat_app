import 'package:catalogat_app/core/dependencies.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:catalogat_app/domain/entities/entities.dart';
import 'package:catalogat_app/presentation/blocs/blocs.dart';
import 'package:catalogat_app/presentation/widgets/widgets.dart';
import 'package:catalogat_app/presentation/ui/products/widgets/widgets.dart';

class BrandAllProducts extends StatelessWidget {
  const BrandAllProducts({super.key, required this.brand, required this.brandsCubit, required this.orderCubit});

  final BrandEntity brand;
  final BrandsCubit brandsCubit;
  final OrderCubit orderCubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: brandsCubit,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: PrimaryAppBar(title: brand.name, color: AppColors.background),
        body: BlocConsumer<BrandsCubit, BrandsState>(
          listenWhen: (previous, current) {
            if(current.deleteProductResource.isSuccess) return true;
            return false;
          },
          listener: (context, state) {
            if (state.deleteProductResource.isSuccess) {
              if(state.brandsResource.data != null) {
                final brand = state.brandsResource.data!.firstWhere((element) => element.id == this.brand.id);
                if(brand.products.isEmpty) {
                  if(context.mounted) Navigator.of(context).pop();
                }
              }
            }
          },
          buildWhen: (previous, current) {
            if (previous.brandsResource != current.brandsResource) return true;
            return false;
          },
          builder: (context, state) {
            if (state.brandsResource.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            final brand = (state.brandsResource.data ?? []).firstWhere((element) => element.id == this.brand.id);
            return SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: Dimens.horizontalSemiSmall),
                child: Builder(
                  builder: (context) {
                    if(brand.products.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              Assets.icons.icProduct,
                              width: 100.w,
                              height: 100.w,
                            ),
                            Gap(Dimens.verticalXXLarge),
                            Text(context.l10n.empty_product_list, style: TextStyle(color: AppColors.textColor, fontWeight: FontWeight.w500, fontSize: FontSize.medium)),
                          ],
                        ),
                      );
                    }
                    return GridView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: brand.products.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisExtent: 330.h,
                        crossAxisSpacing: 4.w,
                      ),
                      itemBuilder: (context, index) {
                        return ProductItemWidget(
                          orderCubit: orderCubit,
                          item: brand.products[index],
                        );
                      },
                    );
                  }
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
