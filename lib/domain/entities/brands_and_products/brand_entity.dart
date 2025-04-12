import 'package:equatable/equatable.dart';
import 'package:catalogat_app/domain/entities/entities.dart';

class BrandEntity extends Equatable {
  final String? id;
  final String? name;
  final String? logoUrl;
  final List<ProductEntity> products;

  const BrandEntity({
    this.id,
    this.name,
    this.logoUrl,
    this.products = const [],
  });

  @override
  List<Object?> get props => [id, name, logoUrl, products];

  BrandEntity copyWith({
    String? id,
    String? name,
    String? logoUrl,
    List<ProductEntity>? products,
  }) {
    return BrandEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      logoUrl: logoUrl ?? this.logoUrl,
      products: products ?? this.products,
    );
  }

}