import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/domain/entities/entities.dart';
import 'package:catalogat_app/domain/use_cases/use_cases.dart';

part 'customers_state.dart';

class CustomersCubit extends Cubit<CustomersState> {
  CustomersCubit(this._fetchCustomerUseCase) : super(CustomersState());

  final FetchCustomerUseCase _fetchCustomerUseCase;

  void selectCustomer(CustomerEntity customer) {
    emit(state.copyWith(selectedCustomer: customer));
  }

  Future<void> fetchCustomers () async {
    emit(state.copyWith(customersResource: Resource.loading()));
    final customersResource = await _fetchCustomerUseCase();
    emit(state.copyWith(customersResource: customersResource));
  }
}
