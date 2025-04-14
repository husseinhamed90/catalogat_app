import 'dart:io';

import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/data/models/models.dart';
import 'package:catalogat_app/domain/entities/entities.dart';
import 'package:catalogat_app/domain/use_cases/use_cases.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit(this._createOrderUseCase,this._fetchOrdersUseCase, this._generateOrdersReportUseCase) : super(OrderState());

  final CreateOrderUseCase _createOrderUseCase;
  final FetchOrdersUseCase _fetchOrdersUseCase;
  final GenerateOrderReportUseCase _generateOrdersReportUseCase;

  Future<bool> createOrder(CreateOrderParams createOrderParams) async{
    emit(state.copyWith(orderResource: Resource.loading()));
    final orderResource = await _createOrderUseCase(createOrderParams);
    emit(state.copyWith(
        totalPrice: 0.0,
        cartProducts: {},
        orderResource: orderResource,
    ));
    return orderResource.isSuccess;
  }

  Future<void> fetchOrders() async {
    emit(state.copyWith(ordersResource: Resource.loading()));
    final ordersResource = await _fetchOrdersUseCase();
    emit(state.copyWith(ordersResource: ordersResource));
  }

  Future<(String?,String)> generateOrderReport(OrderPdfFileEntity orderPdfFileEntity) async {
    final pdfResource = await _generateOrdersReportUseCase(orderPdfFileEntity);
    emit(state.copyWith(generateOrdersReportResource: pdfResource));
    if(pdfResource.isSuccess){
      return (pdfResource.data?.path ?? '',pdfResource.message ?? '');
    }
    return (null,pdfResource.message ?? 'Error generating report');
  }

  double getTotalPrice(List<ProductCartItemEntity> products) {
    return products.fold(0.0, (previousValue, element) {
      return previousValue + (element.price ?? 0) * (element.quantity ?? 1);
    });
  }

  void updateCartProducts (ProductCartItemEntity product) {
    final cartProducts = Map<String, ProductCartItemEntity>.from(state.cartProducts);
    if (cartProducts.containsKey(product.id)) {
      cartProducts[product.id ?? ""] = product;
    } else {
      cartProducts[product.id ?? ""] = product;
    }
    emit(state.copyWith(
        cartProducts: cartProducts,
        totalPrice: getTotalPrice(cartProducts.values.toList()),
    ));
  }
}
