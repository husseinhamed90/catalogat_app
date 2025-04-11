// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_product_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateProductParams _$UpdateProductParamsFromJson(Map<String, dynamic> json) =>
    UpdateProductParams(
      id: json['product_id'] as String,
      name: json['new_product_name'] as String,
      imageUrl: json['new_product_image'] as String?,
      price1: (json['new_price_1'] as num?)?.toDouble(),
      price2: (json['new_price_2'] as num?)?.toDouble(),
      brandId: json['new_brand_id'] as String?,
      productCode: json['new_product_code'] as String?,
    );

Map<String, dynamic> _$UpdateProductParamsToJson(
  UpdateProductParams instance,
) => <String, dynamic>{
  'product_id': instance.id,
  'new_product_name': instance.name,
  'new_product_image': instance.imageUrl,
  'new_price_1': instance.price1,
  'new_price_2': instance.price2,
  'new_brand_id': instance.brandId,
  'new_product_code': instance.productCode,
};
