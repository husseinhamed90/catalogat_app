import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/domain/entities/entities.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel implements EntityConverter<ProductModel, ProductEntity> {
  final String id;
  final String name;
  final String? imageUrl;
  final double price;
  final String brandId;

  ProductModel({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.price,
    required this.brandId,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);

  @override
  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      name: name,
      imageUrl: imageUrl,
      price: price,
      brandId: brandId,
    );
  }
}