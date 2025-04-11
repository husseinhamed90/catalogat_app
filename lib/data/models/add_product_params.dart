import 'package:catalogat_app/core/dependencies.dart';

part 'add_product_params.g.dart';

@JsonSerializable()
class AddProductParams {
  @JsonKey(name: 'product_name')
  String? name;
  @JsonKey(name: 'product_image')
  String? productImage;
  @JsonKey(name: 'brand_id')
  String? brandId;
  @JsonKey(name: 'price_1')
  double? price1;
  @JsonKey(name: 'price_2')
  double? price2;
  @JsonKey(name: 'product_code')
  String? productCode;

  AddProductParams({
    this.name,
    this.productImage,
    this.brandId,
    this.price1,
    this.price2,
    this.productCode,
  });

  factory AddProductParams.fromJson(Map<String, dynamic> json) =>
      _$AddProductParamsFromJson(json);

  Map<String, dynamic> toJson() => _$AddProductParamsToJson(this);

  AddProductParams copyWith({
    String? name,
    String? brandId,
    double? price1,
    double? price2,
    String? productImage,
    String? productCode,
  }) {
    return AddProductParams(
      name: name ?? this.name,
      productImage: productImage ?? this.productImage,
      brandId: brandId ?? this.brandId,
      price1: price1 ?? this.price1,
      price2: price2 ?? this.price2,
      productCode: productCode ?? this.productCode,
    );
  }
}