import 'package:catalogat_app/core/helpers/resource.dart';
import 'package:catalogat_app/domain/repositories/repositories.dart';

class DeleteSelectedOrdersUseCase {
  final OrdersRepository _orderRepository;

  DeleteSelectedOrdersUseCase(this._orderRepository);

  Future<Resource<int>> call(List<String> ids) async {
   return await _orderRepository.deleteSelectedOrders(ids);
  }
}