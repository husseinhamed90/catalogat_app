import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/presentation/widgets/primary_floating_action_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:catalogat_app/domain/entities/entities.dart';
import 'package:catalogat_app/presentation/blocs/blocs.dart';
import 'package:catalogat_app/presentation/widgets/primary_app_bar.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key, required this.customerCubit});

  final CustomersCubit customerCubit;

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {

  @override
  void initState() {
    super.initState();
    widget.customerCubit.fetchCustomers();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.customerCubit,
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: BlocBuilder<CustomersCubit, CustomersState>(
          buildWhen: (previous, current) {
            if(previous.customersResource != current.customersResource) return true;
            if(previous.selectedCustomers != current.selectedCustomers) return true;
            if(previous.deleteMode != current.deleteMode) return true;
            if(previous.deleteSelectedCustomersResource != current.deleteSelectedCustomersResource) return true;
            return false;
          },
          builder: (context, state) {
            if(!state.deleteMode) return SizedBox.shrink();
            if(state.selectedCustomers.isEmpty) return SizedBox.shrink();
            return Padding(
              padding: EdgeInsets.only(bottom: Dimens.verticalLarge),
              child: PrimaryFloatingActionButton(
                padding: EdgeInsets.all(Dimens.horizontalMedium),
                onPressed: () async{
                  final deleteSelectedCustomersResource = await widget.customerCubit.deleteSelectedCustomers();
                  if(!context.mounted) return;
                  if(deleteSelectedCustomersResource) {
                   ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(context.l10n.message_customers_deleted_successfully),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                  else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(context.l10n.message_customers_deleted_successfully),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
                icon: Builder(
                    builder: (context) {
                      if(state.deleteSelectedCustomersResource.isLoading) {
                        return SizedBox.square(dimension: FontSize.large,child: CircularProgressIndicator());
                      }
                      return Icon(Icons.delete_rounded, size: Dimens.horizontalExtraLarge, color: Colors.white,);
                    }
                ),
              ),
            );
          },
        ),
        appBar: PrimaryAppBar(
          title: context.l10n.title_customers_screen,
          actions: [
            BlocBuilder<CustomersCubit, CustomersState>(
              buildWhen: (previous, current) {
                if(previous.selectedCustomer != current.selectedCustomer) return true;
                if(previous.deleteMode != current.deleteMode) return true;
                return false;
              },
              builder: (context, state) {
                if(state.deleteMode) {
                  return InkWell(
                    onTap: () {
                      widget.customerCubit.toggleDeleteMode();
                    },
                    child: Icon(Icons.clear,size: Dimens.horizontalExtraLarge,),
                  );
                }
                return InkWell(
                  onTap: () {
                    widget.customerCubit.toggleDeleteMode();
                  },
                  child: Icon(Icons.delete_rounded,size: Dimens.horizontalExtraLarge,),
                );
              },
            ),
            Gap(Dimens.horizontalMedium),
          ],
        ),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: BlocBuilder<CustomersCubit, CustomersState>(
            buildWhen: (previous, current) {
              return previous.customersResource != current.customersResource;
            },
            builder: (context, state) {
              if (state.customersResource.isLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final List<CustomerEntity> customers = state.customersResource.data ?? [];
              if (customers.isEmpty) {
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
                      Text(context.l10n.empty_customers_list, style: TextStyle(color: AppColors.textColor, fontWeight: FontWeight.w500, fontSize: FontSize.medium)),
                    ],
                  ),
                );
              }
              return ListView.builder(
                itemCount: state.customersResource.data?.length ?? 0,
                itemBuilder: (context, index) {
                  final customer = state.customersResource.data![index];
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(Dimens.verticalXSmall),
                    margin: EdgeInsets.only(
                      left: Dimens.horizontalLarge,
                      right: Dimens.horizontalLarge,
                      bottom: index == customers.length - 1 ? 90.h : 0,
                      top: Dimens.verticalSemiSmall,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(customer.name,
                                style: TextStyle(
                                  fontSize: FontSize.medium,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Gap(Dimens.horizontalSmall),
                            BlocBuilder<CustomersCubit, CustomersState>(
                              buildWhen: (previous, current) {
                                if(previous.selectedCustomers[customers[index].id] != current.selectedCustomers[customers[index].id]) return true;
                                if(previous.deleteMode != current.deleteMode) return true;
                                return false;
                              },
                              builder: (context, state) {
                                if(!state.deleteMode) return SizedBox.shrink();
                                return Checkbox(
                                  visualDensity: VisualDensity.compact,
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // reduces default padding
                                  value: state.selectedCustomers.containsKey(customer.id) && state.selectedCustomers[customer.id] == true,
                                  onChanged: (bool? value) {
                                    widget.customerCubit.addCustomerToDeletedMap(customer);
                                  },
                                  checkColor: Colors.white, // color of the check mark (✓)
                                  activeColor: Colors.black, // background when checked
                                  fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                                    if (states.contains(WidgetState.selected)) {
                                      return Colors.black; // checkbox background when selected
                                    }
                                    return Colors.white; // background when not selected
                                  }),
                                  side: const BorderSide(color: Colors.black, width: 2), // black border
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
