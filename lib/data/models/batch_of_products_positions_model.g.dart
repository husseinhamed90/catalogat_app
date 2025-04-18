// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'batch_of_products_positions_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BatchOfProductsPositionsModel _$BatchOfProductsPositionsModelFromJson(
  Map<String, dynamic> json,
) => BatchOfProductsPositionsModel(
  products:
      (json['products'] as List<dynamic>)
          .map((e) => OrderedProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$BatchOfProductsPositionsModelToJson(
  BatchOfProductsPositionsModel instance,
) => <String, dynamic>{'products': instance.products};

OrderedProduct _$OrderedProductFromJson(Map<String, dynamic> json) =>
    OrderedProduct(
      id: json['id'] as String,
      position: (json['position'] as num).toInt(),
    );

Map<String, dynamic> _$OrderedProductToJson(OrderedProduct instance) =>
    <String, dynamic>{'id': instance.id, 'position': instance.position};
