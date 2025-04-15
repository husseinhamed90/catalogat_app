// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => OrderModel(
  id: json['id'] as String? ?? '',
  customerId: json['customer_id'] as String?,
  totalPrice: (json['total_price'] as num?)?.toDouble(),
  companyName: json['company_name'] as String?,
  representativeName: json['representative_name'] as String?,
  customerName: json['customer_name'] as String?,
  createdAt:
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
  products:
      (json['products'] as List<dynamic>?)
          ?.map((e) => ProductCartItem.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'customer_id': instance.customerId,
      'total_price': instance.totalPrice,
      'company_name': instance.companyName,
      'representative_name': instance.representativeName,
      'customer_name': instance.customerName,
      'createdAt': instance.createdAt?.toIso8601String(),
      'products': instance.products,
    };
