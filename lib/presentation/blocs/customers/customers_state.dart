part of 'customers_cubit.dart';

class CustomersState extends Equatable {
  const CustomersState({
    this.customerName = '',
    this.selectedCustomer,
    this.deleteMode = false,
    this.selectedCustomers = const {},
    this.customerResource = const Resource.initial(),
    this.customersResource = const Resource.initial(),
    this.deleteSelectedCustomersResource = const Resource.initial(),
  });


  final bool deleteMode;
  final String customerName;
  final CustomerEntity? selectedCustomer;
  final Map<String, bool> selectedCustomers;
  final Resource<CustomerEntity> customerResource;
  final Resource<int> deleteSelectedCustomersResource;
  final Resource<List<CustomerEntity>> customersResource;

  @override
  List<Object?> get props => [
    deleteMode,
    customerName,
    selectedCustomer,
    customerResource,
    customersResource,
    selectedCustomers,
    deleteSelectedCustomersResource
  ];

  CustomersState copyWith({
    bool? deleteMode,
    String? customerName,
    Map<String, bool>? selectedCustomers,
    Optional<CustomerEntity>? selectedCustomer,
    Resource<CustomerEntity>? customerResource,
    Resource<int>? deleteSelectedCustomersResource,
    Resource<List<CustomerEntity>>? customersResource,
  }) {
    return CustomersState(
      deleteMode: deleteMode ?? this.deleteMode,
      customerName: customerName ?? this.customerName,
      customerResource: customerResource ?? this.customerResource,
      selectedCustomers: selectedCustomers ?? this.selectedCustomers,
      customersResource: customersResource ?? this.customersResource,
      selectedCustomer: selectedCustomer != null ? selectedCustomer.value : this.selectedCustomer,
      deleteSelectedCustomersResource: deleteSelectedCustomersResource ?? this.deleteSelectedCustomersResource,
    );
  }
}