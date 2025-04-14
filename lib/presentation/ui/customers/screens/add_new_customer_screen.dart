import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/presentation/blocs/blocs.dart';
import 'package:catalogat_app/presentation/widgets/widgets.dart';

class AddNewCustomerScreen extends StatefulWidget {
  const AddNewCustomerScreen({super.key, required this.customersCubit});

  final CustomersCubit customersCubit;

  @override
  State<AddNewCustomerScreen> createState() => _AddNewCustomerScreenState();
}

class _AddNewCustomerScreenState extends State<AddNewCustomerScreen> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _customerNameController = TextEditingController();

  final FocusNode _customerNameFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.customersCubit,
      child: Scaffold(
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(Dimens.verticalLarge),
          child: SizedBox(
              width: double.infinity,
              child: BlocBuilder<CustomersCubit, CustomersState>(
                buildWhen: (previous, current) {
                  return previous.customerResource != current.customerResource;
                },
                builder: (context, state) {
                  return PrimaryButton(
                    isLoading: state.customerResource.isLoading,
                    onPressed: () async{
                      if (_formKey.currentState!.validate()) {
                        final customerName = _customerNameController.text;
                        final isSuccess = await widget.customersCubit.saveNewCustomer(customerName);
                        if (!context.mounted) return;
                        if (isSuccess) {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(context.l10n.message_customerAddedSuccessfully),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          } else {
                           ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(context.l10n.message_customerAddedFailed),
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
        appBar: PrimaryAppBar(title: context.l10n.action_addCustomer,
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
                TextInputField(
                  label: context.l10n.label_customerName,
                  hint: context.l10n.hint_customerName,
                  controller: _customerNameController,
                  focusNode: _customerNameFocusNode,
                  validator: (value){
                    if (value == null || value.isEmpty) {
                      return context.l10n.error_requiredField;
                    }
                    return null;
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
