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
      productCode: json['productCode'] as String?,
      productName: json['productName'] as String?,
      totalPrice: (json['totalPrice'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ProductCartItemToJson(ProductCartItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quantity': instance.quantity,
      'price': instance.price,
      'productCode': instance.productCode,
      'productName': instance.productName,
      'totalPrice': instance.totalPrice,
    };
