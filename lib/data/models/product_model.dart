import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/domain/entities/entities.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel implements EntityConverter<ProductModel, ProductEntity> {
  final String? id;
  @JsonKey(name: 'product_name')
  final String? name;
  @JsonKey(name: 'product_image')
  final String? imageUrl;
  @JsonKey(name: 'price_1')
  final double? price1;
  @JsonKey(name: 'price_2')
  final double? price2;
  @JsonKey(name: 'brand_id')
  final String? brandId;
  @JsonKey(name: 'product_code')
  final String? productCode;

  @JsonKey(name: 'position')
  final int? position;

  ProductModel({
    this.id,
    this.name,
    this.price1,
    this.price2,
    this.brandId,
    this.imageUrl,
    this.position,
    this.productCode,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);

  @override
  ProductEntity toEntity() {
    print("id : $id");
    print("position : $position");
    return ProductEntity(
      id: id,
      name: name,
      price1: price1,
      price2: price2,
      brandId: brandId,
      position: position,
      imageUrl: imageUrl,
      productCode: productCode,
    );
  }
}