part of 'customers_cubit.dart';

class CustomersState extends Equatable {
  const CustomersState({
    this.customerName = '',
    this.selectedCustomer,
    this.customersResource = const Resource.initial(),
  });

  final String customerName;
  final CustomerEntity? selectedCustomer;
  final Resource<List<CustomerEntity>> customersResource;

  @override
  List<Object?> get props => [
    customerName,
    selectedCustomer,
    customersResource,
  ];

  CustomersState copyWith({
    String? customerName,
    CustomerEntity? selectedCustomer,
    Resource<List<CustomerEntity>>? customersResource,
  }) {
    return CustomersState(
      customerName: customerName ?? this.customerName,
      selectedCustomer: selectedCustomer ?? this.selectedCustomer,
      customersResource: customersResource ?? this.customersResource,
    );
  }
}