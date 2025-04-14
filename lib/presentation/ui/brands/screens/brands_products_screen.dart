import 'package:catalogat_app/core/constants/app_constants.dart';
import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/data/models/create_order_params.dart';
import 'package:catalogat_app/data/models/product_cart_item.dart';
import 'package:catalogat_app/presentation/blocs/blocs.dart';
import 'package:catalogat_app/presentation/widgets/widgets.dart';
import 'package:catalogat_app/presentation/ui/brands/widgets/widgets.dart';

class BrandsProductsScreen extends StatefulWidget {

  const BrandsProductsScreen({super.key});

  @override
  State<BrandsProductsScreen> createState() => _BrandsProductsScreenState();
}

class _BrandsProductsScreenState extends State<BrandsProductsScreen> {

  late OrderCubit _orderCubit;
  late BrandsCubit _brandsCubit;
  late CompanyCubit _companyCubit;
  late CustomersCubit _customersCubit;

  @override
  void initState() {
    super.initState();
    _orderCubit = sl<OrderCubit>();
    _brandsCubit = sl<BrandsCubit>()..getBrands();
    _companyCubit = sl<CompanyCubit>()..getCompany();
    _customersCubit = sl<CustomersCubit>()..fetchCustomers();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create:(_) => _brandsCubit),
        BlocProvider(create: (_) => _orderCubit),
        BlocProvider(create: (_) => _companyCubit),
        BlocProvider(create: (_) => _customersCubit),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: PrimaryAppBar(
          color: Colors.white,
          showBackButton: false,
          titleWidget: BlocBuilder<CompanyCubit, CompanyState>(
            buildWhen: (state, previous) {
              return state.company?.representativeName != previous.company?.representativeName;
            },
            builder: (context, state) {
              final representativeName = state.company?.representativeName ?? context.l10n.label_representativeName;
              if(representativeName.isEmpty) return SizedBox.shrink();
              return AutoSizeText(
                representativeName,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: FontSize.xMedium
                ),
              );
            },
          ),
          leadingWidget: Row(
            children: [
              Gap(Dimens.horizontalSmall),
              PrimaryFloatingActionButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(Routes.editCompanyInfo,
                      arguments: {
                        ArgumentsNames.companyCubit: _companyCubit,
                      }
                  );
                },
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: SvgPicture.asset(
                Assets.icons.icGeneratePdf,
                color: Colors.black,
              ),
              onPressed: () async{
                final generatedFile = await _orderCubit.generateOrdersReport();
                if(!context.mounted) return;
                final path = generatedFile.$1;
                final message = generatedFile.$2;
                if(path != null && path.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.green,
                      content: Text(context.l10n.message_reportGenerated),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(message),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
            Gap(Dimens.horizontalSemiSmall),
          ],
          titleStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: FontSize.xMedium
          ),
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocBuilder<OrderCubit,OrderState>(
                buildWhen: (state, previous) {
                  if(state.totalPrice != previous.totalPrice) return true;
                  if(state.cartProducts != previous.cartProducts) return true;
                  return false;
                },
                builder: (context,state) {
                  if(state.totalPrice == 0) return SizedBox.shrink();
                  return PrimaryFloatingActionButton(
                    icon: Icon(Icons.save_rounded, color: Colors.white, size: FontSize.large,),
                    onPressed: () async{
                      if(_customersCubit.state.selectedCustomer == null) {
                        ScaffoldMessenger.of(globalKey.currentContext!).showSnackBar(
                          SnackBar(
                            content: Text(globalKey.currentContext!.l10n.message_selectCustomer),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      if(!(_companyCubit.state.company?.isDataValid ?? false) ) {
                        ScaffoldMessenger.of(globalKey.currentContext!).showSnackBar(
                          SnackBar(
                            content: Text(globalKey.currentContext!.l10n.message_invalidCompanyData),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      final orderCreated = await _orderCubit.createOrder(
                        CreateOrderParams(
                          totalPrice: state.totalPrice,
                          companyName: _companyCubit.state.company?.name,
                          products: state.cartProducts.values.toList().map(
                            (product) => ProductCartItem(
                              id: product.id,
                              price: product.price,
                              quantity: product.quantity,
                              productName: product.productName,
                              productCode: product.productCode,
                              totalPrice: product.totalPrice,
                            )
                          ).toList(),
                          customerName: _customersCubit.state.selectedCustomer?.name,
                          representativeName: _companyCubit.state.company?.representativeName,
                        )
                      );
                      if (orderCreated) {
                        ScaffoldMessenger.of(globalKey.currentContext!).showSnackBar(
                          SnackBar(
                            content: Text(globalKey.currentContext!.l10n.message_orderSuccess),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                      else {
                        ScaffoldMessenger.of(globalKey.currentContext!).showSnackBar(
                          SnackBar(
                            content: Text(globalKey.currentContext!.l10n.message_orderFailed),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    padding: EdgeInsets.all(Dimens.horizontalMedium),
                  );
                }
            ),
            Gap(Dimens.horizontalSemiSmall),
            BlocBuilder<BrandsCubit,BrandsState>(
                buildWhen: (state, previous) {
                  return state.brandsResource != previous.brandsResource;
                },
                builder: (context,state) {
                  final brands = state.brandsResource.data ?? [];
                  if(brands.isNotEmpty) {
                    return PrimaryFloatingActionButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(Routes.addProduct,arguments: {
                          ArgumentsNames.brandsCubit: _brandsCubit,
                        });
                      },
                      padding: EdgeInsets.all(Dimens.horizontalMedium),
                    );
                  }
                  return SizedBox.shrink();
                }
            ),
          ],
        ),
        body: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CompanyInfoWidget(companyCubit: _companyCubit,orderCubit: _orderCubit,),
              SelectCustomerWidget(customersCubit: _customersCubit),
              BrandsListWidget(brandsCubit: _brandsCubit,orderCubit: _orderCubit),
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