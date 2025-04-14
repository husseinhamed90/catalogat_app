import 'package:catalogat_app/core/constants/app_constants.dart';
import 'package:catalogat_app/presentation/blocs/blocs.dart';
import 'package:catalogat_app/presentation/widgets/widgets.dart';
import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/presentation/ui/brands/widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BrandsListWidget extends StatelessWidget {
  final BrandsCubit brandsCubit;
  final OrderCubit orderCubit;

  const BrandsListWidget({super.key, required this.brandsCubit, required this.orderCubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: brandsCubit,
      child: Container(
        height: 145.h,
        padding: EdgeInsets.symmetric(vertical: Dimens.horizontalMedium),
        width: double.infinity,
        color: Colors.white,
        child: BlocBuilder<BrandsCubit, BrandsState>(
          buildWhen: (previous, current) {
            if(previous.brandsResource != current.brandsResource) return true;
            if(previous.deleteBrandResource != current.deleteBrandResource) return true;
            return false;
          },
          builder: (context, state) {
            if(state.brandsResource.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            final brands = state.brandsResource.data ?? [];
            return ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: brands.length + 1,
              itemBuilder: (context, index) {
                if(index == 0) {
                  return PrimaryAddItemWidget(
                    text: context.l10n.add_brand,
                     onTap: () {
                       Navigator.of(context).pushNamed(
                           Routes.addBrand, arguments: {
                         ArgumentsNames.brandsCubit: brandsCubit,
                       });
                     }
                  );
                }
                final brand = brands[index - 1];
                final child = Stack(
                  children: [
                    BrandItemWidget(
                        brand: brand,
                        isLastItem: index == brands.length,
                        orderCubit: orderCubit
                    ),
                    PositionedDirectional(
                        end: index == brands.length ? 14 : 0,
                        child: CircleAvatar(
                          radius: 12,
                          backgroundColor: Color(0xffF3F4F6),
                          child: PopupMenuButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(Icons.more_vert_outlined, color: AppColors.textColor, size: 17),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 1,
                                child: Text(context.l10n.action_edit, style: TextStyle(color: AppColors.textColor)),
                              ),
                              PopupMenuItem(
                                value: 2,
                                child: Text(context.l10n.action_delete, style: TextStyle(color: AppColors.textColor)),
                              ),
                            ],
                            onSelected: (value) async{
                              if(value == 1) {
                                Navigator.of(context).pushNamed(Routes.editBrand, arguments: {
                                  ArgumentsNames.brand: brand,
                                  ArgumentsNames.brandsCubit: brandsCubit,
                                });
                              } else if(value == 2) {
                                final deletedSuccess = await brandsCubit.deleteBrand(brand.id ?? "");
                                if(deletedSuccess.$1) {
                                  ScaffoldMessenger.of(globalKey.currentContext!).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.green,
                                      content: Text(deletedSuccess.$2 ?? "Brand deleted successfully"),
                                      duration: Duration(seconds: 3),
                                    ),
                                  );
                                }
                                else{
                                  ScaffoldMessenger.of(globalKey.currentContext!).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text(deletedSuccess.$2 ?? "Failed to delete brand"),
                                      duration: Duration(seconds: 4),
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                        )
                    ),
                  ],
                );
                return child;
              },
            );
          },
        ),
      ),
    );
  }
}