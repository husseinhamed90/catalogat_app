import 'package:catalogat_app/core/helpers/resource.dart';
import 'package:catalogat_app/domain/entities/entities.dart';
import 'package:catalogat_app/domain/repositories/repositories.dart';

class FetchOrdersUseCase {
  final OrdersRepository _ordersRepository;

  FetchOrdersUseCase(this._ordersRepository);

  Future<Resource<List<OrderEntity>>> call() async {
    final result = await _ordersRepository.getOrders();
    return result;
  }
}