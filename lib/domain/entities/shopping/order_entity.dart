import 'package:catalogat_app/core/dependencies.dart';

class OrderEntity extends Equatable {
  final String productCode;
  final String productName;
  final int quantity;
  final double totalPrice;

  OrderEntity({
    required this.productCode,
    required this.productName,
    required this.quantity,
    required this.totalPrice,
  });

  @override
  List<Object?> get props => [productCode, productName, quantity, totalPrice];

  OrderEntity copyWith({
    String? productCode,
    String? productName,
    int? quantity,
    double? totalPrice,
  }) {
    return OrderEntity(
      productCode: productCode ?? this.productCode,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}