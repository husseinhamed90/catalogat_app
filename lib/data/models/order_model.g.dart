// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => OrderModel(
  totalPrice: (json['total_price'] as num?)?.toDouble(),
  companyName: json['company_name'] as String?,
  representativeName: json['representative_name'] as String?,
  customerName: json['customer_name'] as String?,
  createdAt:
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      'total_price': instance.totalPrice,
      'company_name': instance.companyName,
      'representative_name': instance.representativeName,
      'customer_name': instance.customerName,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
