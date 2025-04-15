import 'package:catalogat_app/data/models/models.dart';
import 'package:catalogat_app/core/helpers/resource.dart';
import 'package:catalogat_app/domain/entities/entities.dart';

abstract class OrdersRepository {
  Future<Resource<List<OrderEntity>>> getOrders();
  Future<Resource<OrderEntity>> createOrder(CreateOrderParams orderRequest);
  Future<Resource<int>> deleteSelectedOrders(List<String> ids);
}