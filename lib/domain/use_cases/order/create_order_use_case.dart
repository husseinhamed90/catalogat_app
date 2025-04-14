import 'package:catalogat_app/core/helpers/resource.dart';
import 'package:catalogat_app/data/models/models.dart';
import 'package:catalogat_app/domain/entities/entities.dart';
import 'package:catalogat_app/domain/repositories/repositories.dart';

class CreateOrderUseCase {
  final OrdersRepository _ordersRepository;

  CreateOrderUseCase(this._ordersRepository);

  Future<Resource<OrderEntity>> call(CreateOrderParams order) async {
    final result = await _ordersRepository.createOrder(order);
    return result;
  }
}