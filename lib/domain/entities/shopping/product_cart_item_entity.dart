import 'package:catalogat_app/core/dependencies.dart';

class ProductCartItemEntity extends Equatable {

  final String? id;
  final double? price;
  final int? quantity;
  final double? totalPrice;
  final String? productCode;
  final String? productName;

  const ProductCartItemEntity({
    this.id,
    this.price,
    this.quantity,
    this.productCode,
    this.productName,
    this.totalPrice,
  });

  @override
  String toString() {
    return 'ProductCartItemEntity{id: $id, price: $price, quantity: $quantity, productCode: $productCode, productName: $productName, totalPrice: $totalPrice}';
  }

  @override
  List<Object?> get props => [
        id,
        price,
        quantity,
        productCode,
        productName,
        totalPrice,
  ];

  ProductCartItemEntity copyWith({
    String? id,
    double? price,
    int? quantity,
    String? productCode,
    String? productName,
    double? totalPrice,
  }) {
    return ProductCartItemEntity(
      id: id ?? this.id,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      productCode: productCode ?? this.productCode,
      productName: productName ?? this.productName,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}