// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_product_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddProductParams _$AddProductParamsFromJson(Map<String, dynamic> json) =>
    AddProductParams(
      name: json['product_name'] as String?,
      productImage: json['product_image'] as String?,
      brandId: json['brand_id'] as String?,
      price1: (json['price_1'] as num?)?.toDouble(),
      price2: (json['price_2'] as num?)?.toDouble(),
      productCode: json['product_code'] as String?,
    );

Map<String, dynamic> _$AddProductParamsToJson(AddProductParams instance) =>
    <String, dynamic>{
      'product_name': instance.name,
      'product_image': instance.productImage,
      'brand_id': instance.brandId,
      'price_1': instance.price1,
      'price_2': instance.price2,
      'product_code': instance.productCode,
    };
