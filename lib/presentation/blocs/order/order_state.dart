part of 'order_cubit.dart';

class OrderState extends Equatable {

  final double totalPrice;
  final Resource<OrderEntity> orderResource;
  final Resource<OrderEntity> createOrderResource;
  final Resource<List<OrderEntity>> ordersResource;
  final Resource<File> generateOrdersReportResource;
  final Map<String, ProductCartItemEntity> cartProducts;
  final Map<String, bool> selectedOrders;
  final bool deleteMode;
  final Resource<int> deleteSelectedOrdersResource;

  const OrderState({
    this.totalPrice = 0.0,
    this.deleteMode = false,
    this.cartProducts = const {},
    this.selectedOrders = const {},
    this.orderResource = const Resource.initial(),
    this.ordersResource = const Resource.initial(),
    this.createOrderResource = const Resource.initial(),
    this.generateOrdersReportResource = const Resource.initial(),
    this.deleteSelectedOrdersResource = const Resource.initial(),
  });

  @override
  List<Object?> get props => [
    totalPrice,
    selectedOrders,
    deleteMode,
    orderResource,
    ordersResource,
    cartProducts,
    createOrderResource,
    deleteSelectedOrdersResource,
    generateOrdersReportResource,
  ];

  OrderState copyWith({
    bool? deleteMode,
    double? totalPrice,
    Resource<OrderEntity>? orderResource,
    Map<String, bool>? selectedOrders,
    Resource<OrderEntity>? createOrderResource,
    Resource<List<OrderEntity>>? ordersResource,
    Resource<File>? generateOrdersReportResource,
    Resource<int>? deleteSelectedOrdersResource,
    Map<String, ProductCartItemEntity>? cartProducts,
  }) {
    return OrderState(
      deleteMode: deleteMode ?? this.deleteMode,
      totalPrice: totalPrice ?? this.totalPrice,
      cartProducts: cartProducts ?? this.cartProducts,
      orderResource: orderResource ?? this.orderResource,
      ordersResource: ordersResource ?? this.ordersResource,
      selectedOrders: selectedOrders ?? this.selectedOrders,
      createOrderResource: createOrderResource ?? this.createOrderResource,
      generateOrdersReportResource: generateOrdersReportResource ?? this.generateOrdersReportResource,
      deleteSelectedOrdersResource: deleteSelectedOrdersResource ?? this.deleteSelectedOrdersResource,
    );
  }
}