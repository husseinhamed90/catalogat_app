import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/presentation/blocs/blocs.dart';
import 'package:catalogat_app/presentation/widgets/widgets.dart';
import 'package:catalogat_app/presentation/ui/brands/widgets/widgets.dart';

class BrandsProductsScreen extends StatefulWidget {

  const BrandsProductsScreen({super.key});

  @override
  State<BrandsProductsScreen> createState() => _BrandsProductsScreenState();
}

class _BrandsProductsScreenState extends State<BrandsProductsScreen> {

  late BrandsCubit _brandsCubit;

  @override
  void initState() {
    super.initState();
    _brandsCubit = sl<BrandsCubit>()..getBrands();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _brandsCubit,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: PrimaryAppBar(
          isCenterTitle: false,
          showBackButton: false,
          titleStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: FontSize.extraLarge
          ),
          title: context.l10n.title_brandsAndProducts,
          color: Color(0xffFFFFFB),
        ),
        floatingActionButton: BlocBuilder<BrandsCubit,BrandsState>(
            buildWhen: (state, previous) {
              return state.brandsResource != previous.brandsResource;
            },
            builder: (context,state) {
              final brands = state.brandsResource.data ?? [];
              if(brands.isNotEmpty) {
                return FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(Routes.addProduct,arguments: {
                      ArgumentsNames.brandsCubit: _brandsCubit,
                    });
                  },
                  backgroundColor: Colors.black,
                  child: Icon(Icons.add, color: Colors.white),
                );
              }
              return SizedBox.shrink();
            }
        ),
        body: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BrandsListWidget(brandsCubit: _brandsCubit),
              Expanded(
                child: BlocBuilder<BrandsCubit,BrandsState>(
                    buildWhen: (previous, current) {
                      if(previous.deleteProductResource != current.deleteProductResource) return true;
                      if(previous.brandsResource != current.brandsResource) return true;
                      return false;
                    },
                    builder: (context, state) {
                      if(state.brandsResource.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final brands = state.brandsResource.data ?? [];
                      if(brands.isEmpty) {
                        return Material(
                          color: Colors.white,
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Color(0xffE8F4FF),
                                  radius: 100,
                                  child: SvgPicture.asset(Assets.icons.icHome),
                                ),
                                Gap(Dimens.verticalExtraLarge),
                                AutoSizeText(
                                  context.l10n.empty_brand_list,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: FontSize.extraLarge
                                  ),
                                ),
                                Gap(Dimens.verticalMedium),
                                AutoSizeText(
                                  textAlign: TextAlign.center,
                                  context.l10n.label_addFirstBrand,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff666666),
                                      fontSize: FontSize.medium
                                  ),
                                ),
                                Gap(Dimens.verticalXXXLarge),

                              ],
                            ),
                          ),
                        );
                      }
                      return BrandProductsListWidget(
                        brands: state.brandsResource.data ?? []
                      );
                    }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}