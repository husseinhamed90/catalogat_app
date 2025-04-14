import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/domain/entities/order/customer_entity.dart';
import 'package:catalogat_app/presentation/blocs/blocs.dart';
import 'package:catalogat_app/presentation/widgets/primary_add_item_widget.dart';
import 'package:catalogat_app/presentation/widgets/primary_drop_down.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectCustomerWidget extends StatelessWidget {
  const SelectCustomerWidget({super.key, required this.customersCubit});

  final CustomersCubit customersCubit;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryAddItemWidget(
            onTap: (){
              Navigator.of(context).pushNamed(
                Routes.addNewCustomer,
                arguments: {
                  ArgumentsNames.customersCubit: customersCubit,
                },
              );
            },
            text: context.l10n.label_addCustomer,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: Dimens.horizontalXSmall,
              ),
              height: 80.h,
              child: Center(
                child: BlocBuilder<CustomersCubit,CustomersState>(
                  buildWhen: (previousState, currentState) {
                    if(previousState.customersResource != currentState.customersResource) return true;
                    return false;
                  },
                  builder: (context, state) {
                    if (state.customersResource.isLoading) {
                      return const CircularProgressIndicator();
                    }
                    return PrimaryDropDown<CustomerEntity>(
                      items: state.customersResource.data ?? [],
                      selectedItem: state.selectedCustomer,
                      hintText: context.l10n.label_selectCustomer,
                      onChanged: (value) {
                        if (value != null) {
                          customersCubit.selectCustomer(value);
                        }
                      },
                      validator: (value) => null,
                      displayValue: (item) => item.name,
                    );
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
