import 'dart:io';

import 'package:catalogat_app/core/constants/app_constants.dart';
import 'package:catalogat_app/core/services/photo_picker.dart';
import 'package:catalogat_app/data/models/models.dart';
import 'package:catalogat_app/domain/entities/entities.dart';
import 'package:catalogat_app/presentation/blocs/blocs.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';
import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/presentation/widgets/widgets.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key, required this.brandsCubit, required this.product});

  final BrandsCubit brandsCubit;
  final ProductEntity product;

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {

  final _formKey = GlobalKey<FormState>();

  final FocusNode _productNameFocusNode = FocusNode();
  final TextEditingController _productNameController = TextEditingController();

  final FocusNode _productPrice1FocusNode = FocusNode();
  final TextEditingController _productPrice1Controller = TextEditingController();

  final FocusNode _productPrice2FocusNode = FocusNode();
  final TextEditingController _productPrice2Controller = TextEditingController();

  final FocusNode _productCodeFocusNode = FocusNode();
  final TextEditingController _productCodeController = TextEditingController();

  late BrandsCubit _brandsCubit;

  late List<BrandEntity> _brands;

  @override
  void initState() {
    super.initState();
    _brandsCubit = widget.brandsCubit;
    _brandsCubit.resetState();
    _productNameController.text = widget.product.name ?? "";
    _productCodeController.text = widget.product.productCode ?? "";
    _productPrice1Controller.text = (widget.product.price1 ?? 0).toString();
    _productPrice2Controller.text = (widget.product.price2 ?? 0).toString();
    _brands = widget.brandsCubit.state.brandsResource.data ?? [];
    final brand = _brands.firstWhere((brand) => brand.id == widget.product.brandId,orElse: () => BrandEntity());
    if(brand.id != null) {
      _brandsCubit.selectedBrand(brand);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _brandsCubit,
      child: PrimaryScaffold(
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(Dimens.verticalLarge),
          child: SizedBox(
            width: double.infinity,
            child: BlocBuilder<BrandsCubit, BrandsState>(
              buildWhen: (previous, current) {
                if(previous.selectedBrand != current.selectedBrand) return true;
                if(previous.updateProductResource != current.updateProductResource) return true;
                return false;
              },
              builder: (context, state) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () async{
                    if (_formKey.currentState!.validate()) {
                      final updateProductSuccess = await _brandsCubit.updateProduct(
                        updateProductParams: UpdateProductParams(
                          id: widget.product.id ?? "",
                          name: _productNameController.text,
                          brandId: state.selectedBrand?.id ?? "",
                          productCode: _productCodeController.text,
                          imageUrl: widget.product.imageUrl,
                          price1: double.tryParse(_productPrice1Controller.text),
                          price2: double.tryParse(_productPrice2Controller.text),
                        )
                      );
                      if(updateProductSuccess.$1) {
                        _brandsCubit.getBrands(false);
                        ScaffoldMessenger.of(globalKey.currentContext!).showSnackBar(
                          SnackBar(
                            content: Text(updateProductSuccess.$2 ?? "Product updated successfully"),
                            backgroundColor: Colors.green,
                          ),
                        );
                        if(context.mounted) Navigator.of(context).pop();
                      }
                      else{
                        ScaffoldMessenger.of(globalKey.currentContext!).showSnackBar(
                          SnackBar(
                            content: Text(updateProductSuccess.$2 ?? "Failed to update product"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  child: Builder(
                    builder: (context) {
                      if (state.updateProductResource.isLoading) {
                        return CircularProgressIndicator(
                          color: Colors.white,
                        );
                      }
                      return Text(context.l10n.action_editProduct, style: TextStyle(fontSize: FontSize.medium, color: Colors.white));
                    }
                  ),
                );
              },
            ),
          ),
        ),
        backgroundColor: AppColors.background,
        appBar: PrimaryAppBar(title: context.l10n.title_edit_product_screen, color: AppColors.background,),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.all(Dimens.verticalLarge),
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Gap(Dimens.verticalLarge),
                  InkWell(
                    borderRadius: BorderRadius.circular(90),
                    onTap: () async {
                      final pickedFile = await PhotoPickerService.pickImage(
                        ImageSource.gallery,
                      );
                      if (pickedFile != null) {
                        _brandsCubit.setFileImage(pickedFile);
                      }
                    },
                    child: BlocBuilder<BrandsCubit,BrandsState>(
                      bloc: _brandsCubit,
                        buildWhen: (prevState, currentState) {
                          if (prevState.imageFile != currentState.imageFile) return true;
                          return false;
                        },
                        builder: (context,state) {
                          if (state.imageFile == null && widget.product.imageUrl == null) {
                            return DottedBorder(
                              padding: EdgeInsets.zero,
                              borderType: BorderType.Circle,
                              dashPattern: [6, 3],
                              child: CircleAvatar(
                                radius: 90,
                                backgroundColor: Colors.transparent,
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SvgPicture.asset(
                                        Assets.icons.icCamera,
                                        width: 40,
                                        height: 40,
                                      ),
                                      Gap(Dimens.verticalSemiSmall),
                                      Text(
                                        context.l10n.label_addProductImage,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: FontSize.xSmall,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(90),
                            child: Builder(
                                builder: (context) {
                                  if (state.imageFile?.path.isNotEmpty ?? false) {
                                    return CircleAvatar(
                                      radius: 90,
                                      backgroundColor: Colors.transparent,
                                      backgroundImage: FileImage(
                                        File(state.imageFile!.path),
                                      ),
                                    );
                                  }
                                  if(widget.product.imageUrl != null) {
                                    return CircleAvatar(
                                      radius: 90,
                                      backgroundColor: Colors.transparent,
                                      backgroundImage: NetworkImage(
                                        widget.product.imageUrl ?? "",
                                      ),
                                    );
                                  }
                                  return CircleAvatar(
                                    radius: 90,
                                    backgroundColor: Colors.transparent,
                                    child: Center(
                                      child: SvgPicture.asset(
                                        Assets.icons.icCamera,
                                        width: 40,
                                        height: 40,
                                      ),
                                    ),
                                  );
                                }
                            ),
                          );
                        }
                    ),
                  ),
                  Gap(Dimens.verticalLarge),
                  BlocBuilder<BrandsCubit, BrandsState>(
                    buildWhen: (previous, current) {
                      if(previous.productName != current.productName) return true;
                      return false;
                    },
                    builder: (context, state) {
                      return TextInputField(
                        maxLines: 3,
                        focusNode: _productNameFocusNode,
                        controller: _productNameController,
                        hint: context.l10n.label_productNameHint,
                        label: context.l10n.label_productName,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.l10n.error_requiredField;
                          }
                          return null;
                        },
                      );
                    },
                  ),
                  Gap(Dimens.verticalLarge),
                  BlocBuilder<BrandsCubit, BrandsState>(
                    buildWhen: (previous, current) {
                      if(previous.productCode != current.productCode) return true;
                      return false;
                    },
                    builder: (context, state) {
                      return TextInputField(
                        focusNode: _productCodeFocusNode,
                        controller: _productCodeController,
                        hint: context.l10n.label_productCodeHint,
                        label: context.l10n.label_productCode,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.l10n.error_requiredField;
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _brandsCubit.setProductCode(value);
                        },
                      );
                    },
                  ),
                  Gap(Dimens.verticalLarge),
                  BlocBuilder<BrandsCubit, BrandsState>(
                    buildWhen: (previous, current) {
                      if(previous.productPrice1 != current.productPrice1) return true;
                      return false;
                    },
                    builder: (context, state) {
                      return AmountInputField(
                        focusNode: _productPrice1FocusNode,
                        controller: _productPrice1Controller,
                        label: context.l10n.label_price1,
                        hint: context.l10n.label_price1Hint,
                        onChanged: (value) {
                          _brandsCubit.setProductPrice1(value);
                        },
                      );
                    },
                  ),
                  Gap(Dimens.verticalLarge),
                  BlocBuilder<BrandsCubit, BrandsState>(
                    buildWhen: (previous, current) {
                      if(previous.productPrice2 != current.productPrice2) return true;
                      return false;
                    },
                    builder: (context, state) {
                      return AmountInputField(
                        focusNode: _productPrice2FocusNode,
                        controller: _productPrice2Controller,
                        label: context.l10n.label_price2,
                        hint: context.l10n.label_price2Hint,
                        onChanged: (value) {
                          _brandsCubit.setProductPrice2(value);
                        },
                      );
                    },
                  ),
                  Gap(Dimens.verticalLarge),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.label_selectBrand,
                        style: TextStyle(
                          fontSize: FontSize.medium,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Gap(Dimens.verticalSemiSmall),
                      BlocBuilder<BrandsCubit, BrandsState>(
                        buildWhen: (previous, current) {
                          if(previous.selectedBrand != current.selectedBrand) return true;
                          return false;
                        },
                        builder: (context, state) {
                          return DropdownButtonFormField<BrandEntity>(
                            value: state.selectedBrand,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.name == null || value.name!.isEmpty) {
                                return context.l10n.error_requiredField;
                              }
                              return null;
                            },
                            hint: Text(context.l10n.label_selectBrandHint, style: TextStyle(color: Colors.grey.shade400)),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(
                                    color: Colors.grey.shade300),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(
                                    color: Colors.grey.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(color: AppColors.blue),
                              ),
                            ),
                            items: _brands.map((brand) => DropdownMenuItem<BrandEntity>(
                              value: brand,
                              child: Text(brand.name ?? ""),
                            )).toList(),
                            onChanged: (value) {
                             _brandsCubit.selectedBrand(value);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}