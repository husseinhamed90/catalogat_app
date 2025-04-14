import 'dart:io';

import 'package:catalogat_app/core/constants/app_constants.dart';
import 'package:catalogat_app/core/services/photo_picker.dart';
import 'package:catalogat_app/data/models/models.dart';
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
            padding: EdgeInsets.all(Dimens.verticalLarge),
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
                      final isExists = widget.brandsCubit.checkIfBrandNameExists(_brandNameController.text.trim());
                      if (isExists) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(context.l10n.error_brandNameAlreadyExists),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                        return;
                      }
                      if (_formKey.currentState!.validate()) {
                        final updateBrandSuccess = await widget.brandsCubit.updateBrand(
                          UpdateBrandParams(
                            id: widget.brand.id ?? "",
                            name: _brandNameController.text,
                          )
                        );
                        if (updateBrandSuccess.$1) {
                          widget.brandsCubit.getBrands(false);
                          ScaffoldMessenger.of(globalKey.currentContext!).showSnackBar(
                            SnackBar(
                              content: Text(updateBrandSuccess.$2 ?? "Brand updated successfully"),
                              backgroundColor: Colors.green,
                            ),
                          );
                          if(context.mounted) Navigator.of(context).pop();
                        }
                        else {
                          ScaffoldMessenger.of(globalKey.currentContext!).showSnackBar(
                            SnackBar(
                              content: Text(updateBrandSuccess.$2 ?? "Failed to update brand"),
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
                        return Text(context.l10n.action_editBrand, style: TextStyle(fontSize: FontSize.medium, color: Colors.white));
                      }
                    ),
                  );
                },
              ),
            ),
          ),
          backgroundColor: AppColors.background,
          appBar: PrimaryAppBar(title: context.l10n.title_edit_brand_screen, color: AppColors.background),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            padding: EdgeInsets.all(Dimens.verticalLarge),
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
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
                        widget.brandsCubit.setFileImage(pickedFile);
                      }
                    },
                    child: BlocBuilder<BrandsCubit,BrandsState>(
                      buildWhen: (prevState, currentState) {
                        if (prevState.imageFile != currentState.imageFile) return true;
                        return false;
                      },
                      builder: (context,state) {
                        if (state.imageFile == null && widget.brand.logoUrl == null) {
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
                                      context.l10n.label_addBrandImage,
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
                                if(widget.brand.logoUrl != null) {
                                  return CircleAvatar(
                                    radius: 90,
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: NetworkImage(
                                      widget.brand.logoUrl ?? "",
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
                  Gap(Dimens.verticalXXXLarge),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextInputField(
                        controller: _brandNameController,
                        focusNode: _brandNameFocusNode,
                        label: context.l10n.label_brandName,
                        hint: context.l10n.label_brandNameHint,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.l10n.error_requiredField;
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