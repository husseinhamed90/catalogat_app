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

  final List<Map<String, dynamic>> products = [
    {
      "brand": "Nike",
      "items": []
    },
    {
      "brand": "Adidas",
      "items": [
        {
          "name": "Ultraboost",
          "image": "https://images.pexels.com/photos/1172064/pexels-photo-1172064.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
          "price": "\$180"
        },
        {
          "name": "Stan Smith",
          "image": "https://images.pexels.com/photos/1172064/pexels-photo-1172064.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
          "price": "\$85"
        }
      ]
    },
    {
      "brand": "Puma",
      "items": [
        {
          "name": "RS-X",
          "image": "https://images.pexels.com/photos/1172064/pexels-photo-1172064.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
          "price": "\$110"
        },
        {
          "name": "Suede Classic",
          "image": "https://images.pexels.com/photos/1172064/pexels-photo-1172064.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
          "price": "\$70"
        },
        {
          "name": "Suede Classic",
          "image": "https://images.pexels.com/photos/1172064/pexels-photo-1172064.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
          "price": "\$70"
        },
        {
          "name": "Suede Classic",
          "image": "https://images.pexels.com/photos/1172064/pexels-photo-1172064.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
          "price": "\$70"
        }
      ]
    }
  ];

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
          title: "Brands & Products",
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
                  backgroundColor: AppColors.blue,
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
                                Gap(Dimens.extraLarge),
                                AutoSizeText(
                                  "No Brands Yet",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: FontSize.extraLarge
                                  ),
                                ),
                                Gap(Dimens.medium),
                                AutoSizeText(
                                  textAlign: TextAlign.center,
                                  "Start To Add Your First Brand",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff666666),
                                      fontSize: FontSize.medium
                                  ),
                                ),
                                Gap(Dimens.xxxLarge),

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