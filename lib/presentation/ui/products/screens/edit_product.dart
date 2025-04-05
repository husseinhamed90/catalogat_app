import 'dart:io';

import 'package:catalogat_app/core/constants/app_constants.dart';
import 'package:catalogat_app/core/services/photo_picker.dart';
import 'package:catalogat_app/domain/entities/brand_entity.dart';
import 'package:catalogat_app/domain/entities/product_entity.dart';
import 'package:catalogat_app/presentation/blocs/blocs.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/presentation/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';

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

  late BrandsCubit _brandsCubit;

  late List<BrandEntity> _brands;

  @override
  void initState() {
    super.initState();
    _brandsCubit = widget.brandsCubit;
    _brandsCubit.resetState();
    _productNameController.text = widget.product.name ?? "";
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
      child: GestureDetector(
        onTap: () {
          if (_productNameFocusNode.hasFocus) _productNameFocusNode.unfocus();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(Dimens.large),
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
                          product: widget.product.copyWith(
                            name: _productNameController.text,
                          ),
                        );
                        if(updateProductSuccess) {
                          _brandsCubit.getBrands(false);
                          ScaffoldMessenger.of(globalKey.currentContext!).showSnackBar(
                            SnackBar(
                              content: Text("Product Updated Successfully"),
                              backgroundColor: Colors.green,
                            ),
                          );
                          if(mounted) {
                            Navigator.of(globalKey.currentContext!).pop();
                          }
                        }
                        else{
                          ScaffoldMessenger.of(globalKey.currentContext!).showSnackBar(
                            SnackBar(
                              content: Text(state.updateBrandResource.message ?? "Error"),
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
                        return Text("Update Product", style: TextStyle(fontSize: FontSize.medium, color: Colors.white));
                      }
                    ),
                  );
                },
              ),
            ),
          ),
          backgroundColor: AppColors.background,
          appBar: PrimaryAppBar(title: "Update Product", color: AppColors.background,),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.all(Dimens.large),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Gap(Dimens.xxLarge),
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
                                      Gap(Dimens.semiSmall),
                                      Text(
                                        "Add product image",
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
                    Gap(Dimens.xxxLarge),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Product Name",
                          style: TextStyle(
                            fontSize: FontSize.medium,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        Gap(Dimens.semiSmall),
                        TextFormField(
                          focusNode: _productNameFocusNode,
                          controller: _productNameController,
                          decoration: InputDecoration(
                            hintText: "Enter product name",
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(color: AppColors.blue),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Product name is required";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    Gap(Dimens.xxLarge),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Product Brand",
                          style: TextStyle(
                            fontSize: FontSize.medium,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        Gap(Dimens.semiSmall),
                        BlocBuilder<BrandsCubit, BrandsState>(
                          buildWhen: (previous, current) {
                            if(previous.selectedBrand != current.selectedBrand) return true;
                            return false;
                          },
                          builder: (context, state) {
                            return DropdownButtonFormField<BrandEntity>(
                              value: state.selectedBrand,
                              validator: (value) {
                                if (value == null || value.name == null || value.name!.isEmpty) {
                                  return "Product Brand is required";
                                }
                                return null;
                              },
                              hint: Text("Select Brand",
                                  style: TextStyle(color: Colors.grey.shade400)),
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
      ),
    );
  }
}