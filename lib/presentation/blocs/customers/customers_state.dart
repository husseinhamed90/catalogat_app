part of 'customers_cubit.dart';

class CustomersState extends Equatable {
  const CustomersState({
    this.customerName = '',
    this.selectedCustomer,
    this.customerResource = const Resource.initial(),
    this.customersResource = const Resource.initial(),

  });

  final String customerName;
  final CustomerEntity? selectedCustomer;
  final Resource<CustomerEntity> customerResource;
  final Resource<List<CustomerEntity>> customersResource;

  @override
  List<Object?> get props => [
    customerName,
    selectedCustomer,
    customerResource,
    customersResource,
  ];

  CustomersState copyWith({
    String? customerName,
    Optional<CustomerEntity>? selectedCustomer,
    Resource<CustomerEntity>? customerResource,
    Resource<List<CustomerEntity>>? customersResource,
  }) {
    return CustomersState(
      customerName: customerName ?? this.customerName,
      selectedCustomer: selectedCustomer != null
          ? selectedCustomer.value
          : this.selectedCustomer,
      customerResource: customerResource ?? this.customerResource,
      customersResource: customersResource ?? this.customersResource,
    );
  }
}