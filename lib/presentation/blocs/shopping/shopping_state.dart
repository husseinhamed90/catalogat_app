part of 'shopping_cubit.dart';

class ShoppingState extends Equatable {

  final int quantity;
  final Resource<OrderEntity> orderResource;
  final Resource<List<OrderEntity>> ordersResource;
  final Resource<File> generateOrdersReportResource;

  const ShoppingState({
    this.quantity = 1,
    this.orderResource = const Resource.initial(),
    this.ordersResource = const Resource.initial(),
    this.generateOrdersReportResource = const Resource.initial(),
  });

  @override
  List<Object> get props => [
    quantity,
    orderResource,
    ordersResource,
    generateOrdersReportResource,
  ];

  ShoppingState copyWith({
    int? quantity,
    Resource<OrderEntity>? orderResource,
    Resource<List<OrderEntity>>? ordersResource,
    Resource<File>? generateOrdersReportResource,
  }) {
    return ShoppingState(
      quantity: quantity ?? this.quantity,
      orderResource: orderResource ?? this.orderResource,
      ordersResource: ordersResource ?? this.ordersResource,
      generateOrdersReportResource: generateOrdersReportResource ?? this.generateOrdersReportResource,
    );
  }
}
