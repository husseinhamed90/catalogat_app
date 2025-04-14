import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/domain/entities/order/customer_entity.dart';
import 'package:catalogat_app/domain/entities/shopping/product_cart_item_entity.dart';

class OrderEntity extends Equatable {
  final double totalPrice;
  final String companyName;
  final String customerName;
  final DateTime? createdAt;
  final String representativeName;
  final List<ProductCartItemEntity> products;

  const OrderEntity({
    this.totalPrice = 0.0,
    this.companyName = '',
    this.customerName = '',
    this.createdAt,
    this.representativeName = '',
    this.products = const [],
  });

  @override
  List<Object?> get props => [
        totalPrice,
        companyName,
        customerName,
        createdAt,
        representativeName,
        products,
  ];

  OrderEntity copyWith({
    double? totalPrice,
    String? companyName,
    String? customerName,
    DateTime? createdAt,
    String? representativeName,
    List<ProductCartItemEntity>? products,
    CustomerEntity? customer,
  }) {
    return OrderEntity(
      totalPrice: totalPrice ?? this.totalPrice,
      companyName: companyName ?? this.companyName,
      customerName: customerName ?? this.customerName,
      createdAt: createdAt ?? this.createdAt,
      representativeName: representativeName ?? this.representativeName,
      products: products ?? this.products,
    );
  }
}