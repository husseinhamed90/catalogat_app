import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String? id;
  final String? name;
  final double? price1;
  final double? price2;
  final String? brandId;
  final String? imageUrl;
  final String? productCode;

  const ProductEntity({
    this.id,
    this.name,
    this.price1,
    this.price2,
    this.brandId,
    this.imageUrl,
    this.productCode,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    price1,
    price2,
    brandId,
    imageUrl,
    productCode,
  ];

  ProductEntity copyWith({
    String? id,
    String? name,
    double? price1,
    double? price2,
    String? brandId,
    String? imageUrl,
    String? productCode,
  }) {
    return ProductEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      price1: price1 ?? this.price1,
      price2: price2 ?? this.price2,
      brandId: brandId ?? this.brandId,
      imageUrl: imageUrl ?? this.imageUrl,
      productCode: productCode ?? this.productCode,
    );
  }
}