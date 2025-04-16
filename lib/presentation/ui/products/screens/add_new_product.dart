import 'dart:io';

import 'package:catalogat_app/core/constants/app_constants.dart';
import 'package:catalogat_app/core/services/photo_picker.dart';
import 'package:catalogat_app/data/models/models.dart';
import 'package:catalogat_app/domain/entities/entities.dart';
import 'package:catalogat_app/presentation/blocs/blocs.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/presentation/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';

class AddNewProductScreen extends StatefulWidget {
  const AddNewProductScreen({super.key, required this.brandsCubit});

  final BrandsCubit brandsCubit;

  @override
  State<AddNewProductScreen> createState() => _AddNewProductScreenState();
}

class _AddNewProductScreenState extends State<AddNewProductScreen> {

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
    _brands = _brandsCubit.state.brandsResource.data ?? [];
    _brandsCubit.resetState();
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
                if(previous.addProductResource != current.addProductResource) return true;
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
                      final addProductSuccess = await _brandsCubit.addProduct(
                        addProductParams: AddProductParams(
                          name: _productNameController.text,
                          brandId: state.selectedBrand?.id,
                          productCode: _productCodeController.text,
                          price1: double.tryParse(_productPrice1Controller.text),
                          price2: double.tryParse(_productPrice2Controller.text),
                        ),
                      );
                      if(addProductSuccess.$1) {
                        _brandsCubit.getBrands(false);
                        ScaffoldMessenger.of(globalKey.currentContext!).showSnackBar(
                          SnackBar(
                            content: Text(addProductSuccess.$2),
                            backgroundColor: Colors.green,
                          ),
                        );
                        if(context.mounted) Navigator.of(context).pop();
                      }
                      else{
                        ScaffoldMessenger.of(globalKey.currentContext!).showSnackBar(
                          SnackBar(
                            content: Text(addProductSuccess.$2),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  child: Builder(
                      builder: (context) {
                        if (state.addProductResource.isLoading) {
                          return CircularProgressIndicator(
                            color: Colors.white,
                          );
                        }
                        return Text(context.l10n.action_createProduct, style: TextStyle(fontSize: FontSize.medium, color: Colors.white));
                      }
                  ),
                );
              },
            ),
          ),
        ),
        backgroundColor: AppColors.background,
        appBar: PrimaryAppBar(title: context.l10n.title_add_product_screen, color: AppColors.background,),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.all(Dimens.verticalLarge),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Gap(Dimens.verticalXXLarge),
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
                          if (state.imageFile != null) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(90),
                              child: Image.file(
                                File(state.imageFile!.path),
                                fit: BoxFit.cover,
                                width: 180,
                                height: 180,
                              ),
                            );
                          }
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
                        controller: _productNameController,
                        focusNode: _productNameFocusNode,
                        label: context.l10n.label_productName,
                        onChanged: (value) {
                          _brandsCubit.setProductName(value);
                        },
                        hint: context.l10n.label_productNameHint,
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
                        controller: _productCodeController,
                        focusNode: _productCodeFocusNode,
                        label: context.l10n.label_productCode,
                        onChanged: (value) {
                          _brandsCubit.setProductCode(value);
                        },
                        hint: context.l10n.label_productCodeHint,
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
                          return PrimaryDropDown(
                            selectedItem: state.selectedBrand,
                            items: _brands,
                            hintText: context.l10n.label_selectBrandHint,
                            onChanged: (value) {
                              _brandsCubit.selectedBrand(value);
                            },
                            validator: (value) {
                              if (value == null || value.name == null || value.name!.isEmpty) {
                                return context.l10n.error_requiredField;
                              }
                              return null;
                            },
                            displayValue: (BrandEntity item) => item.name ?? "",
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
