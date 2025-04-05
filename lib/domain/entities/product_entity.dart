import 'package:catalogat_app/data/models/models.dart';
import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String? id;
  final String? name;
  final double? price;
  final String? brandId;
  final String? imageUrl;

  const ProductEntity({
    this.id,
    this.name,
    this.price,
    this.brandId,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    price,
    brandId,
    imageUrl,
  ];

  ProductEntity copyWith({
    String? id,
    String? name,
    double? price,
    String? brandId,
    String? imageUrl,
  }) {
    return ProductEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      brandId: brandId ?? this.brandId,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  ProductModel get toModel {
    return ProductModel(
      id: id ?? '',
      name: name ?? '',
      imageUrl: imageUrl,
      price: price ?? 0.0,
      brandId: brandId ?? '',
    );
  }
}