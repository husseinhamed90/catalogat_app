// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_order_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateOrderParams _$CreateOrderParamsFromJson(Map<String, dynamic> json) =>
    CreateOrderParams(
      totalPrice: (json['total_price'] as num?)?.toDouble(),
      companyName: json['company_name'] as String?,
      customerName: json['customer_name'] as String?,
      representativeName: json['representative_name'] as String?,
      products:
          (json['products'] as List<dynamic>?)
              ?.map((e) => ProductCartItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$CreateOrderParamsToJson(CreateOrderParams instance) =>
    <String, dynamic>{
      'company_name': instance.companyName,
      'representative_name': instance.representativeName,
      'customer_name': instance.customerName,
      'total_price': instance.totalPrice,
      'products': instance.products,
    };
