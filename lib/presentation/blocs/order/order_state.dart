part of 'order_cubit.dart';

class OrderState extends Equatable {

  final double totalPrice;
  final Resource<OrderEntity> orderResource;
  final Resource<OrderEntity> createOrderResource;
  final Resource<List<OrderEntity>> ordersResource;
  final Resource<File> generateOrdersReportResource;
  final Map<String, ProductCartItemEntity> cartProducts;

  const OrderState({
    this.totalPrice = 0.0,
    this.cartProducts = const {},
    this.orderResource = const Resource.initial(),
    this.ordersResource = const Resource.initial(),
    this.createOrderResource = const Resource.initial(),
    this.generateOrdersReportResource = const Resource.initial(),
  });

  @override
  List<Object?> get props => [
    totalPrice,
    orderResource,
    ordersResource,
    cartProducts,
    createOrderResource,
    generateOrdersReportResource,
  ];

  OrderState copyWith({
    double? totalPrice,
    Resource<OrderEntity>? orderResource,
    Map<String, ProductCartItemEntity>? cartProducts,
    Resource<OrderEntity>? createOrderResource,
    Resource<List<OrderEntity>>? ordersResource,
    Resource<File>? generateOrdersReportResource,
  }) {
    return OrderState(
      totalPrice: totalPrice ?? this.totalPrice,
      cartProducts: cartProducts ?? this.cartProducts,
      orderResource: orderResource ?? this.orderResource,
      ordersResource: ordersResource ?? this.ordersResource,
      createOrderResource: createOrderResource ?? this.createOrderResource,
      generateOrdersReportResource: generateOrdersReportResource ?? this.generateOrdersReportResource,
    );
  }
}