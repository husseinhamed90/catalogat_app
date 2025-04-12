import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/domain/entities/order/customer_entity.dart';
import 'package:catalogat_app/domain/use_cases/use_cases.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit(this._fetchCustomerUseCase) : super(OrderState()){
    fetchCustomers();
  }

  final FetchCustomerUseCase _fetchCustomerUseCase;

  void updateCustomerName(String name) {
    emit(state.copyWith(customerName: name));
  }

  void selectCustomer(CustomerEntity customer) {
    emit(state.copyWith(selectedCustomer: customer));
  }

  Future<void> fetchCustomers () async {
    emit(state.copyWith(customersResource: Resource.loading()));
    final customersResource = await _fetchCustomerUseCase();
    emit(state.copyWith(customersResource: customersResource));
  }

  void changeTabIndex(int index) {
    emit(state.copyWith(currentTabIndex: index));
  }
}
