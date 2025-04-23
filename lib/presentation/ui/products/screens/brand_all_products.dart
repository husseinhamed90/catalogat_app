import 'package:animated_reorderable_list/animated_reorderable_list.dart';
import 'package:catalogat_app/core/constants/app_constants.dart';
import 'package:catalogat_app/core/dependencies.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:catalogat_app/domain/entities/entities.dart';
import 'package:catalogat_app/presentation/blocs/blocs.dart';
import 'package:catalogat_app/presentation/widgets/widgets.dart';
import 'package:catalogat_app/presentation/ui/products/widgets/widgets.dart';

class BrandAllProducts extends StatefulWidget {
  const BrandAllProducts({super.key, required this.brand, required this.brandsCubit, required this.orderCubit});

  final BrandEntity brand;
  final BrandsCubit brandsCubit;
  final OrderCubit orderCubit;

  @override
  State<BrandAllProducts> createState() => _BrandAllProductsState();
}

class _BrandAllProductsState extends State<BrandAllProducts> {

  final List <Widget> generatedChildren = [];

  List<ProductEntity> _products = [];

  @override
  void initState() {
    _products = widget.brand.products;
    _pendingProducts = List.from(_products);
    super.initState();
    _generateImageData();
  }

  void _showConfirmationDialog() {
    showDialog(
      context: globalKey.currentContext!,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
            globalKey.currentContext?.l10n.popUp_title_applyChanges ?? "",
            style: TextStyle(
                fontSize: FontSize.large,
                fontWeight: FontWeight.w600,
                color: AppColors.textColor
            )
        ),
        content: Text(
            globalKey.currentContext?.l10n.popUp_confirmation ?? "",
            style: TextStyle(
                fontSize: FontSize.medium,
                fontWeight: FontWeight.w400,
                color: AppColors.textColor
            )
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _discardChanges();
            },
            child: Text(
                globalKey.currentContext?.l10n.action_ignore ?? "",
                style: TextStyle(
                    fontSize: FontSize.medium,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textColor
                )
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _applyChanges();
            },
            child: Text(
                globalKey.currentContext?.l10n.action_yes ?? "",
                style: TextStyle(
                    fontSize: FontSize.medium,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textColor
                )
            ),
          ),
        ],
      ),
    );
  }

  List<ProductEntity> _pendingProducts = [];

  void _applyChanges() {
    for(int i = 0; i < _pendingProducts.length; i++) {
      _pendingProducts[i] = _pendingProducts[i].copyWith(position: i);
    }
    setState(() {
      _products = List.from(_pendingProducts);
    });
    widget.brandsCubit.reorderBrandProducts(_products, widget.brand.id ?? "");
  }

  void _discardChanges() {
    setState(() {
      _pendingProducts = List.from(_products);
    });
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.brandsCubit,
      child: PrimaryScaffold(
        backgroundColor: AppColors.background,
        appBar: PrimaryAppBar(
            actions: [
              BlocBuilder<BrandsCubit, BrandsState>(
                buildWhen: (previous, current) {
                  if (previous.generatePdfFileResource != current.generatePdfFileResource) return true;
                  return false;
                },
                builder: (context, state) {
                  if (state.generatePdfFileResource.isLoading) {
                    return Center(child: Container(
                      width: 30.w,
                      height: 30.w,
                      padding: EdgeInsets.all(4.0),
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    ));
                  }
                  return IconButton(
                    icon: SvgPicture.asset(
                      Assets.icons.icGeneratePdf,
                      color: Colors.black,
                    ),
                    onPressed: () async{
                      widget.brandsCubit.getBrandProductsPdf(widget.brand);
                    },
                  );
                },
              ),
              Gap(Dimens.horizontalSemiSmall),
            ],
            title: widget.brand.name,
            color: AppColors.background
        ),
        body: BlocConsumer<BrandsCubit, BrandsState>(
          listenWhen: (previous, current) {
            if(current.deleteProductResource.isSuccess) return true;
            return false;
          },
          listener: (context, state) {
            if (state.deleteProductResource.isSuccess) {
              if(state.brandsResource.data != null) {
                final brand = state.brandsResource.data!.firstWhere((element) => element.id == widget.brand.id);
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
            _pendingProducts = state.brandsResource.data?.firstWhere((element) => element.id == widget.brand.id).products ?? [];
            return SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: Dimens.horizontalSemiSmall),
                child: Builder(
                  builder: (context) {
                    if(_pendingProducts.isEmpty) {
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
                    return AnimatedReorderableGridView(
                      items: _pendingProducts,
                      itemBuilder: (BuildContext context, int index) {
                        final product = _pendingProducts[index];
                        return ProductItemWidget(
                          key: ValueKey(product.id),
                          orderCubit: widget.orderCubit,
                          item: product,
                        );
                      },
                      sliverGridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisExtent: 330.h,
                        crossAxisSpacing: 4.w,
                      ),
                      enterTransition: [FlipInX(), ScaleIn()],
                      exitTransition: [SlideInLeft()],
                      insertDuration: const Duration(milliseconds: 300),
                      removeDuration: const Duration(milliseconds: 300),
                      onReorder: (oldIndex, newIndex) {
                        setState(() {
                          final product = _pendingProducts.removeAt(oldIndex);
                          _pendingProducts.insert(newIndex, product);
                        });
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _showConfirmationDialog();
                        });
                      },
                      dragStartDelay: const Duration(milliseconds: 300),
                      isSameItem: (a, b) => a.id == b.id,
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
  void _generateImageData() {
    generatedChildren.clear();
    for (var product in _pendingProducts) {
      generatedChildren.add(
          KeyedSubtree(
              key: Key(product.id ?? ""),
              child:ProductItemWidget(
                  orderCubit: widget.orderCubit,
                  item: product
              )
          )
      );
    }
  }
}

