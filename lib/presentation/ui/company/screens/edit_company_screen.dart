import 'dart:io';

import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/presentation/blocs/blocs.dart';
import 'package:catalogat_app/presentation/widgets/widgets.dart';

class EditCompanyScreen extends StatefulWidget {
  const EditCompanyScreen({super.key, required this.companyCubit});

  final CompanyCubit companyCubit;

  @override
  State<EditCompanyScreen> createState() => _EditCompanyScreenState();
}

class _EditCompanyScreenState extends State<EditCompanyScreen> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _representativeNameController = TextEditingController();

  final FocusNode _companyNameFocusNode = FocusNode();
  final FocusNode _representativeNameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _companyNameController.text = widget.companyCubit.state.companyName;
    _representativeNameController.text = widget.companyCubit.state.companyRepresentativeName;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.companyCubit,
      child: PrimaryScaffold(
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(Dimens.verticalLarge),
          child: SizedBox(
              width: double.infinity,
              child: BlocBuilder<CompanyCubit, CompanyState>(
                buildWhen: (previous, current) {
                  if (previous.saveCompanyResource != current.saveCompanyResource) return true;
                  if (previous.companyName != current.companyName) return true;
                  if (previous.companyRepresentativeName != current.companyRepresentativeName) return true;
                  if (previous.logoFile != current.logoFile) return true;
                  return false;
                },
                builder: (context, state) {
                  return PrimaryButton(
                    isLoading: state.saveCompanyResource.isLoading,
                    onPressed: () async {
                      if((state.company?.logoUrl ?? "").isNotEmpty || (state.logoFile != null && state.logoFile!.path.isNotEmpty) ){
                        if (_formKey.currentState!.validate()) {
                          final companyInfoSaved = await widget.companyCubit.saveCompany();
                          if (companyInfoSaved) {
                            if (context.mounted) {
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      context.l10n.message_companyInfoSaved),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          } else {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      context.l10n.message_companyInfoNotSaved),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          }
                        }
                      }
                      else{
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  context.l10n.message_companyLogoRequired),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      }
                    },
                    title: context.l10n.action_save,
                  );
                },
              )
          ),
        ),
        backgroundColor: AppColors.background,
        appBar: PrimaryAppBar(title: context.l10n.title_edit_company_screen,
            color: AppColors.background),
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
                BlocBuilder<CompanyCubit, CompanyState>(
                  buildWhen: (previous, current) {
                    if (previous.logoFile != current.logoFile) return true;
                    if (previous.company?.logoUrl != current.company?.logoUrl) return true;
                    return false;
                  },
                  builder: (context, state) {
                    return PrimaryChangeableImage(
                      imageUrl: state.company?.logoUrl,
                      imageFile: state.logoFile,
                      labelText: context.l10n.label_companyLogo,
                      onImageChanged: (file) {
                        widget.companyCubit.updateLogoFile(File(file.path));
                      },
                    );
                  },
                ),
                Gap(Dimens.verticalXXLarge),
                BlocBuilder<CompanyCubit, CompanyState>(
                  buildWhen: (previous, current) {
                    return previous.companyName != current.companyName;
                  },
                  builder: (context, state) {
                    return TextInputField(
                      label: context.l10n.label_companyName,
                      hint: context.l10n.hint_companyName,
                      controller: _companyNameController,
                      focusNode: _companyNameFocusNode,
                      onChanged: (value) {
                        widget.companyCubit.updateCompanyName(value,);
                      },
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
                BlocBuilder<CompanyCubit, CompanyState>(
                  buildWhen: (previous, current) {
                    return previous.companyRepresentativeName != current.companyRepresentativeName;
                  },
                  builder: (context, state) {
                    return TextInputField(
                      label: context.l10n.label_representativeName,
                      hint: context.l10n.hint_representativeName,
                      controller: _representativeNameController,
                      focusNode: _representativeNameFocusNode,
                      onChanged: (value) {
                        widget.companyCubit.updateCompanyRepresentative(value);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return context.l10n.error_requiredField;
                        }
                        return null;
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
