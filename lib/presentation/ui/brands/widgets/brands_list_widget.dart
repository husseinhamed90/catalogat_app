import 'package:catalogat_app/core/constants/app_constants.dart';
import 'package:catalogat_app/presentation/blocs/blocs.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/presentation/ui/brands/widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BrandsListWidget extends StatelessWidget {
  final BrandsCubit brandsCubit;

  const BrandsListWidget({super.key, required this.brandsCubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: brandsCubit,
      child: Container(
        height: 144.h,
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
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(Routes.addBrand,arguments: {
                        ArgumentsNames.brandsCubit: brandsCubit,
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(Dimens.medium),
                      child: Column(
                        children: [
                          Center(
                            child: DottedBorder(
                              padding: EdgeInsets.zero,
                              borderType: BorderType.Circle,
                              dashPattern: [6, 3],
                              color: AppColors.blue,
                              child: CircleAvatar(
                                radius: 40.r,
                                backgroundColor: Colors.transparent,
                                child: Icon(Icons.add, color: AppColors.blue, size: 30),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          AutoSizeText(context.l10n.add_brand, style: TextStyle(color: AppColors.blue, fontWeight: FontWeight.w500, fontSize: FontSize.xSmall)),
                        ],
                      ),
                    ),
                  );
                }
                final brand = brands[index - 1];
                final child = Stack(
                  children: [
                    BrandItemWidget(brand: brand),
                    PositionedDirectional(
                        top: 14,
                        end: 14,
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
