import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/domain/entities/entities.dart';
import 'package:catalogat_app/domain/use_cases/use_cases.dart';

part 'customers_state.dart';

class CustomersCubit extends Cubit<CustomersState> {
  CustomersCubit(this._fetchCustomerUseCase, this._saveNewCustomerUseCase, this._deleteSelectedCustomersUseCase) : super(CustomersState());

  final FetchCustomerUseCase _fetchCustomerUseCase;
  final SaveNewCustomerUseCase _saveNewCustomerUseCase;
  final DeleteSelectedCustomersUseCase _deleteSelectedCustomersUseCase;

  void selectCustomer(CustomerEntity customer) {
    emit(state.copyWith(selectedCustomer: Optional(customer)));
  }

  Future<void> fetchCustomers () async {
    emit(state.copyWith(
        customersResource: Resource.loading(),
        deleteMode: false,
        selectedCustomers: {}
    ));
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

  bool checkIfCustomerNameExists(String text) {
    final customers = (state.customersResource.data ?? []).where((customer) => customer.name == text);
    return customers.isNotEmpty;
  }

  /// select or unselect order
  void addCustomerToDeletedMap(CustomerEntity customer) {
    final selectedCustomers = Map<String, bool>.from(state.selectedCustomers);
    if (selectedCustomers.containsKey(customer.id)) {
      selectedCustomers.remove(customer.id);
    } else {
      selectedCustomers[customer.id ?? ""] = true;
    }
    emit(state.copyWith(selectedCustomers: selectedCustomers));
  }

  Future<bool> deleteSelectedCustomers() async {
    emit(state.copyWith(deleteSelectedCustomersResource: Resource.loading()));
    final List<String> ids = state.selectedCustomers.keys.toList();
    final deleteSelectedCustomersResource = await _deleteSelectedCustomersUseCase(ids);
    List<CustomerEntity> customers = [];
    if(deleteSelectedCustomersResource.isSuccess) {
      customers = (state.customersResource.data ?? []).where((customer) => !ids.contains(customer.id)).toList();
      final isCurrentSelectedCustomerExistInDeletedCustomers = ids.contains(state.selectedCustomer?.id);
      emit(state.copyWith(
          customersResource: Resource.success(customers),
          selectedCustomer: isCurrentSelectedCustomerExistInDeletedCustomers
              ? Optional<CustomerEntity>(null)
              : Optional(state.selectedCustomer),
      ));
    }
    else{
      customers = state.customersResource.data ?? [];
    }
    emit(state.copyWith(
        deleteMode: false,
        selectedCustomers: {},
        customersResource: Resource.success(customers),
        deleteSelectedCustomersResource: deleteSelectedCustomersResource
    ));
    return deleteSelectedCustomersResource.isSuccess;
  }

  void toggleDeleteMode() {
    emit(state.copyWith(
        deleteMode: !state.deleteMode,
        selectedCustomers: state.deleteMode ? {} : state.selectedCustomers
    ));
  }
}
