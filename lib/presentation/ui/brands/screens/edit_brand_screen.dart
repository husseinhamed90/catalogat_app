import 'dart:io';

import 'package:catalogat_app/core/constants/app_constants.dart';
import 'package:catalogat_app/core/services/photo_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/domain/entities/entities.dart';
import 'package:catalogat_app/presentation/blocs/blocs.dart';
import 'package:catalogat_app/presentation/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';

class EditBrandScreen extends StatefulWidget {
  const EditBrandScreen({super.key, required this.brandsCubit, required this.brand});

  final BrandsCubit brandsCubit;
  final BrandEntity brand;

  @override
  State<EditBrandScreen> createState() => _EditBrandScreenState();
}

class _EditBrandScreenState extends State<EditBrandScreen> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _brandNameController = TextEditingController();
  final FocusNode _brandNameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    widget.brandsCubit.resetState();
    _brandNameController.text = widget.brand.name ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.brandsCubit,
      child: GestureDetector(
        onTap: () {
          if (_brandNameFocusNode.hasFocus) _brandNameFocusNode.unfocus();
        },
        child: Scaffold(
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(Dimens.large),
            child: SizedBox(
              width: double.infinity,
              child: BlocBuilder<BrandsCubit, BrandsState>(
                buildWhen: (prevState, currentState) {
                  if(prevState.updateBrandResource != currentState.updateBrandResource) return true;
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
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final updateBrandSuccess = await widget.brandsCubit.updateBrand(
                          widget.brand.copyWith(
                            name: _brandNameController.text,
                          ),
                        );
                        if (updateBrandSuccess) {
                          widget.brandsCubit.getBrands(false);
                          ScaffoldMessenger.of(globalKey.currentContext!).showSnackBar(
                            SnackBar(
                              content: Text("Brand Updated Successfully"),
                              backgroundColor: Colors.green,
                            ),
                          );
                          if(mounted) Navigator.pop(context);
                        }
                        else {
                          ScaffoldMessenger.of(globalKey.currentContext!).showSnackBar(
                            SnackBar(
                              content: Text("Failed to Update brand"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    child: Builder(
                      builder: (context) {
                        if (state.updateBrandResource.isLoading) {
                          return const CircularProgressIndicator(
                            color: Colors.white,
                          );
                        }
                        return Text("Update brand", style: TextStyle(fontSize: FontSize.medium, color: Colors.white));
                      }
                    ),
                  );
                },
              ),
            ),
          ),
          backgroundColor: AppColors.background,
          appBar: PrimaryAppBar(title: "Update Brand", color: AppColors.background),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.all(Dimens.large),
            child: Form(
              key: _formKey,
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
                        widget.brandsCubit.setFileImage(pickedFile);
                      }
                    },
                    child: BlocBuilder<BrandsCubit,BrandsState>(
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
                                    "Add brand image",
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
                        "Brand Name",
                        style: TextStyle(
                          fontSize: FontSize.medium,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Gap(Dimens.semiSmall),
                      TextFormField(
                        focusNode: _brandNameFocusNode,
                        controller: _brandNameController,
                        decoration: InputDecoration(
                          hintText: "Enter brand name",
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
                            return "Brand name is required";
                          }
                          return null;
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