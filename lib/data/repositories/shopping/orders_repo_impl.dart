import 'package:catalogat_app/data/models/models.dart';
import 'package:catalogat_app/core/helpers/resource.dart';
import 'package:catalogat_app/domain/entities/entities.dart';
import 'package:catalogat_app/data/sources/supabase_service.dart';
import 'package:catalogat_app/domain/repositories/repositories.dart';

class OrdersRepositoryImpl implements OrdersRepository {


  final SupabaseService _supabaseService;

  OrdersRepositoryImpl(this._supabaseService);

  @override
  Future<Resource<OrderEntity>> createOrder(CreateOrderParams orderRequest) async{
    try {
      final apiResponse = await _supabaseService.createOrder(orderRequest);
      return apiResponse.toResource((data) => data.toEntity());
    } catch (e) {
      return Resource.failure("Failed to create order");
    }
  }

  @override
  Future<Resource<List<OrderEntity>>> getOrders() async {
    try {
      final apiResponse = await _supabaseService.getOrders();
      return apiResponse.toResource((data) => data.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Resource.failure("Failed to get orders");
    }
  }

  @override
  Future<Resource<int>> deleteSelectedOrders(List<String> ids) async {
    try {
      final apiResponse = await _supabaseService.deleteOrders(DeleteItemsRequest(ids: ids));
      return apiResponse.toResource((data) => data.toEntity());
    } catch (e) {
      return Resource.failure("Failed to delete orders");
    }
  }
}