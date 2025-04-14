import 'dart:io';

import 'package:catalogat_app/core/constants/app_constants.dart';
import 'package:catalogat_app/core/services/photo_picker.dart';
import 'package:catalogat_app/data/models/models.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/presentation/blocs/blocs.dart';
import 'package:catalogat_app/presentation/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';

class AddBrandScreen extends StatefulWidget {
  const AddBrandScreen({super.key, required this.brandsCubit});

  final BrandsCubit brandsCubit;

  @override
  State<AddBrandScreen> createState() => _AddBrandScreenState();
}

class _AddBrandScreenState extends State<AddBrandScreen> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _brandNameController = TextEditingController();
  final FocusNode _brandNameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    widget.brandsCubit.resetState();
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
                  if(prevState.addBrandResource != currentState.addBrandResource) return true;
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
                      /// check if brand name is not already exists
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
                      return;
                      if (_formKey.currentState!.validate()) {
                        final addBrandSuccess = await widget.brandsCubit.addBrand(
                          requestModel: AddBrandParams(
                            name: _brandNameController.text,
                          ),
                        );
                        if (addBrandSuccess.$1) {
                          widget.brandsCubit.getBrands(false);
                          ScaffoldMessenger.of(globalKey.currentContext!).showSnackBar(
                            SnackBar(
                              content: Text(addBrandSuccess.$2 ?? "Brand created successfully"),
                              backgroundColor: Colors.green,
                            ),
                          );
                          if(context.mounted) Navigator.pop(context);
                        }
                        else {
                          ScaffoldMessenger.of(globalKey.currentContext!).showSnackBar(
                            SnackBar(
                              content: Text(addBrandSuccess.$2 ?? "Failed to create brand"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    child: Builder(
                      builder: (context) {
                        if (state.addBrandResource.isLoading) {
                          return const CircularProgressIndicator(
                            color: Colors.white,
                          );
                        }
                        return Text(context.l10n.action_addBrand, style: TextStyle(fontSize: FontSize.medium, color: Colors.white));
                      }
                    ),
                  );
                },
              ),
            ),
          ),
          backgroundColor: AppColors.background,
          appBar: PrimaryAppBar(title: context.l10n.title_add_brand_screen, color: AppColors.background),
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
                    ),
                  ),
                  Gap(Dimens.verticalXXLarge),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextInputField(
                        label: context.l10n.label_brandName,
                        focusNode: _brandNameFocusNode,
                        controller: _brandNameController,
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