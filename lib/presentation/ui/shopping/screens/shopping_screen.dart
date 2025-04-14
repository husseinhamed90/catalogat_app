import 'package:flutter/services.dart';
import 'package:catalogat_app/core/dependencies.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:catalogat_app/domain/entities/entities.dart';
import 'package:catalogat_app/presentation/blocs/blocs.dart';
import 'package:catalogat_app/presentation/widgets/widgets.dart';
import 'package:catalogat_app/core/constants/app_constants.dart';

class ShoppingScreen extends StatefulWidget {
  const ShoppingScreen({super.key, required this.product, required this.productCartItem});

  final ProductEntity product;
  final ProductCartItemEntity productCartItem;

  @override
  State<ShoppingScreen> createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  late ShoppingCubit shoppingCubit;

  final TextEditingController _quantityController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _quantityController.text = "0";
    shoppingCubit = sl<ShoppingCubit>()..setQuantity(widget.productCartItem.quantity ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => shoppingCubit,
      child: Scaffold(
          backgroundColor: AppColors.background,
          resizeToAvoidBottomInset: true,
          bottomNavigationBar: Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: Dimens.horizontalMedium, vertical: Dimens.verticalMedium),
            child: BlocBuilder<ShoppingCubit, ShoppingState>(
              buildWhen: (previous, current) {
                if(previous.quantity != current.quantity) return true;
                if(previous.orderResource != current.orderResource) return true;
                return false;
              },
              builder: (context, state) {
                return PrimaryButton(
                  title: context.l10n.action_save,
                  isLoading: state.orderResource.isLoading,
                  onPressed: () async {
                    ScaffoldMessenger.of(globalKey.currentContext!).showSnackBar(
                      SnackBar(
                        content: Text(globalKey.currentContext!.l10n.message_itemAddedToCart),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pop(context,widget.productCartItem.copyWith(
                      id: widget.product.id,
                      price: widget.product.price2,
                      quantity: shoppingCubit.state.quantity,
                      productCode: widget.product.productCode,
                      productName: widget.product.name,
                      totalPrice: shoppingCubit.getTotalPrice(widget.product.price2 ?? 0),
                    ));
                  },
                );
              },
            ),
          ),
          appBar: PrimaryAppBar(
              title: context.l10n.title_shopping_screen,
              color: AppColors.background
          ),
          body: SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Container(
                    color: AppColors.background,
                    padding: EdgeInsets.only(
                      bottom: Dimens.verticalMedium,
                    ),
                    child: Builder(
                      builder: (context) {
                        if (widget.product.imageUrl == null || widget.product.imageUrl!.isEmpty) {
                          return Image.asset(
                            Assets.images.imgPlaceholder.path,
                            width: double.infinity,
                            height: 300.w,
                            fit: BoxFit.contain,
                          );
                        }
                        return Image.network(
                          width: double.infinity,
                          widget.product.imageUrl ?? "",
                          height: 300.w,
                          fit: BoxFit.contain,
                        );
                      }
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: Offset(0, 0),
                          ),
                        ],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: Dimens.horizontalMedium),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Gap(Dimens.verticalLarge),
                            Text(
                              widget.product.name ?? "",
                              style: TextStyle(
                                fontSize: FontSize.xMedium,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            Gap(Dimens.verticalXSmall),
                            Text(
                              '${widget.product.price2?.formatAsCurrency()} ${context.l10n.currency}',
                              style: TextStyle(
                                fontSize: FontSize.large,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                            Gap(Dimens.verticalXSmall),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: Dimens.horizontalMedium, vertical: Dimens.verticalSmall),
                              decoration: BoxDecoration(
                                color: AppColors.grey,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    context.l10n.label_quantity,
                                    style: TextStyle(
                                      fontSize: FontSize.medium,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: IconButton(
                                          icon: Icon(Icons.remove, color: Colors.black,size: 18.w,),
                                          onPressed: () {
                                            shoppingCubit.decreaseQuantity();
                                          },
                                        ),
                                      ),
                                      Gap(Dimens.horizontalXSmall),
                                      BlocBuilder<ShoppingCubit, ShoppingState>(
                                        buildWhen: (previous, current) {
                                          return previous.quantity != current.quantity;
                                        },
                                        builder: (context, state) {
                                          return IntrinsicWidth(
                                            child: TextField(
                                              inputFormatters: [
                                                FilteringTextInputFormatter.allow(RegExp(r'[\u0660-\u06690-9]')),
                                              ],
                                              keyboardType: TextInputType.number,
                                              onChanged: (v) {
                                                if(v.isEmpty) {
                                                  _quantityController.text = '0';
                                                  shoppingCubit.setQuantity(0);
                                                  return;
                                                }
                                                final String value = v.convertDigitsLangToEnglish;
                                                _quantityController.value = _quantityController.value.copyWith(text: value);
                                                bool isValid = int.tryParse(value) != null;
                                                if (!isValid) _quantityController.text = '0';
                                                int quantity = int.tryParse(value) ?? 0;
                                                if (quantity < 0) {
                                                  _quantityController.text = '0';
                                                  shoppingCubit.setQuantity(0);
                                                  return;
                                                }
                                                _quantityController.text = _quantityController.text.amountFormatter;
                                                _quantityController.selection = TextSelection.fromPosition(TextPosition(offset: _quantityController.text.length));
                                                if(!isValid) {
                                                  _quantityController.text = '';
                                                  shoppingCubit.setQuantity(1);
                                                }
                                                shoppingCubit.setQuantity(int.parse(value));
                                              },
                                              controller: _quantityController..text = state.quantity.toString(),
                                              textAlign: TextAlign.center,
                                              decoration: InputDecoration(
                                                fillColor: AppColors.grey,
                                                border: InputBorder.none,
                                                hintText: '1',
                                                hintStyle: TextStyle(color: Colors.black54),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      Gap(Dimens.horizontalXSmall),
                                      CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: IconButton(
                                          icon: Icon(Icons.add, color: Colors.black,size: 18.w,),
                                          onPressed: () {
                                            shoppingCubit.increaseQuantity();
                                          },
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Gap(Dimens.verticalXSmall),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  context.l10n.label_totalPrice,
                                  style: TextStyle(
                                    fontSize: FontSize.medium,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54,
                                  ),
                                ),
                                BlocBuilder<ShoppingCubit, ShoppingState>(
                                  buildWhen: (previous, current) {
                                    return previous.quantity != current.quantity;
                                  },
                                  builder: (context, state) {
                                    return Text(
                                      '${shoppingCubit.getTotalPrice(widget.product.price2 ?? 0).formatAsCurrency()} ${context.l10n.currency}',
                                      style: TextStyle(
                                        fontSize: FontSize.large,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            Gap(Dimens.verticalXSmall),
                            Divider(
                              color: Colors.grey.withOpacity(0.2),
                              thickness: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }
}
