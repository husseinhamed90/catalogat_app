// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => OrderModel(
  productCode: json['product_code'] as String?,
  productName: json['product_name'] as String?,
  quantity: (json['quantity'] as num?)?.toInt(),
  totalPrice: (json['total_price'] as num?)?.toDouble(),
);

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      'product_code': instance.productCode,
      'product_name': instance.productName,
      'quantity': instance.quantity,
      'total_price': instance.totalPrice,
    };
