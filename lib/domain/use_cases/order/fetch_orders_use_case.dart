import 'package:catalogat_app/core/helpers/resource.dart';
import 'package:catalogat_app/domain/entities/entities.dart';
import 'package:catalogat_app/domain/repositories/repositories.dart';

class FetchOrdersUseCase {
  final OrdersRepository _ordersRepository;

  FetchOrdersUseCase(this._ordersRepository);

  Future<Resource<List<OrderEntity>>> call() async {
    final result = await _ordersRepository.getOrders();
    if (result.isSuccess) {
      result.data?.forEach((order) {
        for (var product in order.products) {
          print('Product: ${product.productName}, Price: ${product.totalPrice}, Quantity: ${product.quantity}');
        }
      });
    }
    return result;
  }
}