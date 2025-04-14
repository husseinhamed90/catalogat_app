import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/domain/entities/entities.dart';
import 'package:catalogat_app/domain/use_cases/use_cases.dart';

part 'customers_state.dart';

class CustomersCubit extends Cubit<CustomersState> {
  CustomersCubit(this._fetchCustomerUseCase, this._saveNewCustomerUseCase) : super(CustomersState());

  final FetchCustomerUseCase _fetchCustomerUseCase;
  final SaveNewCustomerUseCase _saveNewCustomerUseCase;

  void selectCustomer(CustomerEntity customer) {
    emit(state.copyWith(selectedCustomer: Optional(customer)));
  }

  Future<void> fetchCustomers () async {
    emit(state.copyWith(customersResource: Resource.loading()));
    final customersResource = await _fetchCustomerUseCase();
    emit(state.copyWith(customersResource: customersResource));
  }

  Future<bool> saveNewCustomer(String customerName) async {
    emit(state.copyWith(customerResource: Resource.loading()));
    final customerResource = await _saveNewCustomerUseCase(customerName);
    if (customerResource.isSuccess) {
      emit(state.copyWith(customerName: ''));
      fetchCustomers();
    }
    emit(state.copyWith(customerResource: customerResource));
    return customerResource.isSuccess;
  }

  void clearSelectedCustomer() {
    emit(state.copyWith(selectedCustomer: Optional<CustomerEntity>(null)));
  }
}
