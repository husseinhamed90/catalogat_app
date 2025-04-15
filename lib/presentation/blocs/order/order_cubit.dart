import 'dart:io';

import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/data/models/models.dart';
import 'package:catalogat_app/domain/entities/entities.dart';
import 'package:catalogat_app/domain/use_cases/use_cases.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit(this._createOrderUseCase,this._fetchOrdersUseCase, this._generateOrdersReportUseCase, this._deleteSelectedOrdersUseCase) : super(OrderState());

  final CreateOrderUseCase _createOrderUseCase;
  final FetchOrdersUseCase _fetchOrdersUseCase;
  final GenerateOrderReportUseCase _generateOrdersReportUseCase;
  final DeleteSelectedOrdersUseCase _deleteSelectedOrdersUseCase;

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
    emit(state.copyWith(
        ordersResource: Resource.loading(),
        deleteMode: false,
        selectedOrders: {},
    ));
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

  /// select or unselect order
  void selectOrder(OrderEntity order) {
    final selectedOrders = Map<String, bool>.from(state.selectedOrders);
    if (selectedOrders.containsKey(order.id)) {
      selectedOrders.remove(order.id);
    } else {
      selectedOrders[order.id] = true;
    }
    emit(state.copyWith(selectedOrders: selectedOrders));
  }

  void toggleDeleteMode() {
    emit(state.copyWith(
        deleteMode: !state.deleteMode,
        selectedOrders: state.deleteMode ? {} : state.selectedOrders,
    ));
  }

  Future<bool> deleteSelectedOrders() async{
    emit(state.copyWith(deleteSelectedOrdersResource: Resource.loading()));
    final deleteSelectedOrdersResource = await _deleteSelectedOrdersUseCase(state.selectedOrders.keys.toList());
    emit(state.copyWith(deleteSelectedOrdersResource: deleteSelectedOrdersResource));
    List<OrderEntity> orders = [];
    if(deleteSelectedOrdersResource.isSuccess) {
      orders = (state.ordersResource.data ?? []).where((order) => !state.selectedOrders.keys.toList().contains(order.id)).toList();
    }
    else{
      orders = state.ordersResource.data ?? [];
    }
    emit(state.copyWith(
        deleteMode: false,
        selectedOrders: {},
        ordersResource: Resource.success(orders),
        deleteSelectedOrdersResource: deleteSelectedOrdersResource,
    ));
    return deleteSelectedOrdersResource.isSuccess;
  }
}
