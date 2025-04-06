import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/domain/entities/entities.dart';
import 'package:catalogat_app/presentation/blocs/brands/brands_cubit.dart';
import 'package:catalogat_app/presentation/ui/products/widgets/product_item_widget.dart';
import 'package:catalogat_app/presentation/widgets/widgets.dart';

class BrandAllProducts extends StatelessWidget {
  const BrandAllProducts({super.key, required this.brand, required this.brandsCubit});

  final BrandEntity brand;
  final BrandsCubit brandsCubit;

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
              child: Padding(
                padding: const EdgeInsets.all(Dimens.medium),
                child: Builder(
                  builder: (context) {
                    if(brand.products.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              Assets.icons.icProduct,
                              width: 100,
                              height: 100,
                            ),
                            Gap(Dimens.xxLarge),
                            Text("No products added yet", style: TextStyle(color: AppColors.textColor, fontWeight: FontWeight.w500, fontSize: FontSize.medium)),
                          ],
                        ),
                      );
                    }
                    return GridView.builder(
                      itemCount: brand.products.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: Dimens.medium,
                        crossAxisSpacing: Dimens.medium,
                        childAspectRatio: 0.7,
                      ),
                      itemBuilder: (context, index) {
                        return ProductItemWidget(
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
