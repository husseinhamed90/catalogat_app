// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
  id: json['id'] as String?,
  name: json['product_name'] as String?,
  price1: (json['price_1'] as num?)?.toDouble(),
  price2: (json['price_2'] as num?)?.toDouble(),
  brandId: json['brand_id'] as String?,
  imageUrl: json['product_image'] as String?,
  position: (json['position'] as num?)?.toInt(),
  productCode: json['product_code'] as String?,
);

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product_name': instance.name,
      'product_image': instance.imageUrl,
      'price_1': instance.price1,
      'price_2': instance.price2,
      'brand_id': instance.brandId,
      'product_code': instance.productCode,
      'position': instance.position,
    };
