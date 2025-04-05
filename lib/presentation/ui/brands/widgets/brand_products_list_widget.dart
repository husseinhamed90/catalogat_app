import 'package:catalogat_app/domain/entities/entities.dart';
import 'package:catalogat_app/presentation/blocs/blocs.dart';
import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/presentation/ui/products/widgets/widgets.dart';

class BrandProductsListWidget extends StatelessWidget {
  final List<BrandEntity> brands;

  const BrandProductsListWidget({super.key, required this.brands});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: brands.length,
      itemBuilder: (context, index) {
        final brand = brands[index];
        final products = brand.products;
        return Padding(
          padding: const EdgeInsets.only(bottom: Dimens.xxxLarge),
          child: Container(
            padding: const EdgeInsets.only(top: Dimens.medium),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimens.medium),
                  child: Row(
                    children: [
                      Text(brand.name ?? "", style: TextStyle(color: AppColors.textColor, fontWeight: FontWeight.bold, fontSize: FontSize.xMedium)),
                      if(products.isNotEmpty)...[
                        Spacer(),
                        InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed(Routes.productsList, arguments: {
                                ArgumentsNames.brand: brand,
                                ArgumentsNames.brandsCubit: context.read<BrandsCubit>(),
                              });
                            },
                            child: Text("View All", style: TextStyle(color: AppColors.blue, fontWeight: FontWeight.w500, fontSize: FontSize.xSmall))),
                        Gap(7),
                        Icon(Icons.arrow_forward_ios, color: AppColors.blue, size: Dimens.xSmall),
                      ]
                    ],
                  ),
                ),
                Builder(builder: (context) {
                  if(products.isNotEmpty) {
                    return SizedBox(
                      height: 245,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final item = products[index];
                          return ProductItemWidget(item: item);
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
                      height: 150,
                      width: double.infinity,
                      padding: const EdgeInsets.all(Dimens.medium),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              Assets.icons.icProduct,
                              width: 50,
                              height: 50,
                            ),
                            Gap(Dimens.small),
                            Text("No products yet", style: TextStyle(color: AppColors.textColor, fontWeight: FontWeight.w500, fontSize: FontSize.medium)),
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