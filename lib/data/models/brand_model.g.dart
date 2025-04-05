// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BrandModel _$BrandModelFromJson(Map<String, dynamic> json) => BrandModel(
  id: json['id'] as String,
  name: json['name'] as String,
  logoUrl: json['logoUrl'] as String?,
  products:
      (json['products'] as List<dynamic>?)
          ?.map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$BrandModelToJson(BrandModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'logoUrl': instance.logoUrl,
      'products': instance.products,
    };
