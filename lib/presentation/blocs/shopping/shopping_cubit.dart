import 'dart:io';

import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/data/models/create_order_params.dart';
import 'package:catalogat_app/domain/entities/entities.dart';
import 'package:catalogat_app/domain/use_cases/use_cases.dart';

part 'shopping_state.dart';

class ShoppingCubit extends Cubit<ShoppingState> {
  ShoppingCubit(this._createOrderUseCase,this._fetchOrdersUseCase, this._generateOrdersReportUseCase) : super(ShoppingState());

  final CreateOrderUseCase _createOrderUseCase;
  final FetchOrdersUseCase _fetchOrdersUseCase;
  final GenerateOrdersReportUseCase _generateOrdersReportUseCase;

  Future<bool> bookProduct(ProductEntity product) async{
    final order = CreateOrderParams(
      productCode: product.productCode ?? '',
      productName: product.name ?? '',
      quantity: state.quantity,
      totalPrice: getTotalPrice(product.price2 ?? 0),
    );
    emit(state.copyWith(orderResource: Resource.loading()));
    final orderResource = await _createOrderUseCase(order);
    emit(state.copyWith(orderResource: orderResource));
    return orderResource.isSuccess;
  }

  Future<void> fetchOrders() async {
    emit(state.copyWith(ordersResource: Resource.loading()));
    final ordersResource = await _fetchOrdersUseCase();
    emit(state.copyWith(ordersResource: ordersResource));
  }

  void increaseQuantity() => emit(state.copyWith(quantity: state.quantity + 1,));

  void decreaseQuantity() {
    if (state.quantity > 1) {
      emit(state.copyWith(quantity: state.quantity - 1,));
    }
  }

  double getTotalPrice(double productPrice) => productPrice * state.quantity;

  void setQuantity(int quantity) {
    if (quantity > 0) {
      emit(state.copyWith(quantity: quantity));
    } else {
      emit(state.copyWith(quantity: 1));
    }
  }

  Future<(String?,String)> generateOrdersReport() async {
    emit(state.copyWith(generateOrdersReportResource: Resource.loading()));
    final pdfResource = await _generateOrdersReportUseCase();
    emit(state.copyWith(generateOrdersReportResource: pdfResource));
    if(pdfResource.isSuccess){
      return (pdfResource.data?.path ?? '',pdfResource.message ?? '');
    }
    return (null,pdfResource.message ?? 'Error generating report');
  }
}
