// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_cart_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductCartItem _$ProductCartItemFromJson(Map<String, dynamic> json) =>
    ProductCartItem(
      id: json['id'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      quantity: (json['quantity'] as num?)?.toInt(),
      productCode: json['product_code'] as String?,
      productName: json['product_name'] as String?,
      totalPrice: (json['total_price'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ProductCartItemToJson(ProductCartItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quantity': instance.quantity,
      'price': instance.price,
      'product_code': instance.productCode,
      'product_name': instance.productName,
      'total_price': instance.totalPrice,
    };
