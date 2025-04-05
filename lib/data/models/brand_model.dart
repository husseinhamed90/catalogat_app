import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/data/models/models.dart';
import 'package:catalogat_app/domain/entities/entities.dart';

part 'brand_model.g.dart';

@JsonSerializable()
class BrandModel implements EntityConverter<BrandModel, BrandEntity> {
  final String id;
  final String name;
  final String? logoUrl;
  final List<ProductModel> products;

  BrandModel({
    required this.id,
    required this.name,
    this.logoUrl,
    this.products = const [],
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) =>
      _$BrandModelFromJson(json);

  Map<String, dynamic> toJson() => _$BrandModelToJson(this);

  @override
  BrandEntity toEntity() {
    return BrandEntity(
      id: id,
      name: name,
      logoUrl: logoUrl,
      products: products.map((product) => product.toEntity()).toList(),
    );
  }
}