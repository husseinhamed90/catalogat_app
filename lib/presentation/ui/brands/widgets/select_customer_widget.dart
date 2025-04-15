import 'package:catalogat_app/core/dependencies.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:catalogat_app/domain/entities/entities.dart';
import 'package:catalogat_app/presentation/blocs/blocs.dart';
import 'package:catalogat_app/presentation/widgets/widgets.dart';

class SelectCustomerWidget extends StatelessWidget {
  const SelectCustomerWidget({super.key, required this.customersCubit});

  final CustomersCubit customersCubit;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(

        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Gap(Dimens.horizontalSmall),
          PrimaryFloatingActionButton(onPressed: (){
            Navigator.of(context).pushNamed(
              Routes.addNewCustomer,
              arguments: {
                ArgumentsNames.customersCubit: customersCubit,
              },
            );
          }),
          Gap(Dimens.horizontalSmall),
          PrimaryFloatingActionButton(
              onPressed: (){
                Navigator.of(context).pushNamed(
                  Routes.customers,
                  arguments: {
                    ArgumentsNames.customersCubit: customersCubit,
                  },
                );
              },
              icon: SvgPicture.asset(
                Assets.icons.icUsers,
                color: Colors.white,
                height: Dimens.horizontalLarge,
                width: Dimens.horizontalLarge,
              ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: Dimens.horizontalXSmall,
              ),
              height: 62.h,
              child: Center(
                child: BlocBuilder<CustomersCubit,CustomersState>(
                  buildWhen: (previousState, currentState) {
                    if(previousState.customersResource != currentState.customersResource) return true;
                    if(previousState.selectedCustomer != currentState.selectedCustomer) return true;
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
