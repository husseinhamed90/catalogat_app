part of 'order_cubit.dart';

class OrderState extends Equatable {
  final String customerName;
  final int currentTabIndex;
  final CustomerEntity? selectedCustomer;
  final Resource<List<CustomerEntity>> customersResource;

  const OrderState({
    this.customerName = '',
    this.selectedCustomer,
    this.currentTabIndex = 0,
    this.customersResource = const Resource.initial(),
  });

  @override
  List<Object?> get props => [
    customerName,
    currentTabIndex,
    selectedCustomer,
    customersResource,
  ];

  OrderState copyWith({
    int? currentTabIndex,
    String? customerName,
    CustomerEntity? selectedCustomer,
    Resource<List<CustomerEntity>>? customersResource,
  }) {
    return OrderState(
      customerName: customerName ?? this.customerName,
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
      selectedCustomer: selectedCustomer ?? this.selectedCustomer,
      customersResource: customersResource ?? this.customersResource,
    );
  }
}