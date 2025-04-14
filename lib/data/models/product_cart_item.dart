
import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/domain/entities/shopping/product_cart_item_entity.dart';

part 'product_cart_item.g.dart';

@JsonSerializable()
class ProductCartItem implements EntityConverter<ProductCartItem, ProductCartItemEntity> {
  String? id;
  int? quantity;
  double? price;
  String? productCode;
  String? productName;
  double? totalPrice;

  ProductCartItem({
    this.id,
    this.price,
    this.quantity,
    this.productCode,
    this.productName,
    this.totalPrice,
  });

  factory ProductCartItem.fromJson(Map<String, dynamic> json) =>
      _$ProductCartItemFromJson(json);

  Map<String, dynamic> toJson() => _$ProductCartItemToJson(this);

  @override
  ProductCartItemEntity toEntity() {
    return ProductCartItemEntity(
      quantity: quantity,
      productCode: productCode,
      productName: productName,
      totalPrice: totalPrice,
    );
  }

  ProductCartItem copyWith({
    String? id,
    int? quantity,
    double? price,
    String? productCode,
    String? productName,
    double? totalPrice,
  }) {
    return ProductCartItem(
      id: id ?? this.id,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      productCode: productCode ?? this.productCode,
      productName: productName ?? this.productName,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }

}