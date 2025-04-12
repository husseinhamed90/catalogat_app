// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_order_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateOrderParams _$CreateOrderParamsFromJson(Map<String, dynamic> json) =>
    CreateOrderParams(
      productCode: json['product_code'] as String?,
      productName: json['product_name'] as String?,
      quantity: (json['quantity'] as num?)?.toInt(),
      totalPrice: (json['total_price'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$CreateOrderParamsToJson(CreateOrderParams instance) =>
    <String, dynamic>{
      'product_code': instance.productCode,
      'product_name': instance.productName,
      'quantity': instance.quantity,
      'total_price': instance.totalPrice,
    };
