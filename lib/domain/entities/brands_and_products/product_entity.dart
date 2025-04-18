import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String? id;
  final String? name;
  final int? quantity;
  final int? position;
  final double? price1;
  final double? price2;
  final String? brandId;
  final String? imageUrl;
  final double? totalPrice;
  final String? productCode;

  const ProductEntity({
    this.id,
    this.name,
    this.price1,
    this.price2,
    this.brandId,
    this.position,
    this.quantity,
    this.imageUrl,
    this.totalPrice,
    this.productCode,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    price1,
    price2,
    brandId,
    quantity,
    position,
    imageUrl,
    totalPrice,
    productCode,
  ];

  ProductEntity copyWith({
    String? id,
    String? name,
    int? position,
    int? quantity,
    double? price1,
    double? price2,
    String? brandId,
    String? imageUrl,
    double? totalPrice,
    String? productCode,
  }) {
    return ProductEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      price1: price1 ?? this.price1,
      price2: price2 ?? this.price2,
      brandId: brandId ?? this.brandId,
      quantity: quantity ?? this.quantity,
      position: position ?? this.position,
      imageUrl: imageUrl ?? this.imageUrl,
      totalPrice: totalPrice ?? this.totalPrice,
      productCode: productCode ?? this.productCode,
    );
  }
}