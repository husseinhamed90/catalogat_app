import 'package:catalogat_app/core/helpers/resource.dart';
import 'package:catalogat_app/domain/entities/entities.dart';
import 'package:catalogat_app/data/models/models.dart';

abstract class OrdersRepository {
  Future<Resource<List<OrderEntity>>> getOrders();
  Future<Resource<OrderEntity>> createOrder(CreateOrderParams orderRequest);
}