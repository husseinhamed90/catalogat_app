import 'package:catalogat_app/core/dependencies.dart';

part 'update_product_params.g.dart';

@JsonSerializable()
class UpdateProductParams {

  @JsonKey(name: 'product_id')
  final String id;
  @JsonKey(name: 'new_product_name')
  final String name;
  @JsonKey(name: 'new_product_image')
  final String? imageUrl;
  @JsonKey(name: 'new_price_1')
  final double? price1;
  @JsonKey(name: 'new_price_2')
  final double? price2;
  @JsonKey(name: 'new_brand_id')
  final String? brandId;

  UpdateProductParams({
    required this.id,
    required this.name,
    this.imageUrl,
    this.price1,
    this.price2,
    this.brandId,
  });


  Map<String, dynamic> toJson() => _$UpdateProductParamsToJson(this);

  UpdateProductParams copyWith({
    String? id,
    String? name,
    String? imageUrl,
    double? price1,
    double? price2,
    String? brandId,
  }) {
    return UpdateProductParams(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      price1: price1 ?? this.price1,
      price2: price2 ?? this.price2,
      brandId: brandId ?? this.brandId,
    );
  }
}