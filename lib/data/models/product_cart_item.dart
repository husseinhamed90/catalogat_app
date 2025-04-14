
import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/domain/entities/entities.dart';

part 'product_cart_item.g.dart';

@JsonSerializable()
class ProductCartItem implements EntityConverter<ProductCartItem, ProductCartItemEntity> {
  String? id;
  int? quantity;
  double? price;
  @JsonKey(name: 'product_code')
  String? productCode;
  @JsonKey(name: 'product_name')
  String? productName;
  @JsonKey(name: 'total_price')
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
      id: id,
      price: price,
      quantity: quantity,
      totalPrice: totalPrice,
      productCode: productCode,
      productName: productName,
    );
  }

  ProductCartItem copyWith({
    String? id,
    int? quantity,
    double? price,
    double? totalPrice,
    String? productName,
    String? productCode,
  }) {
    return ProductCartItem(
      id: id ?? this.id,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      totalPrice: totalPrice ?? this.totalPrice,
      productCode: productCode ?? this.productCode,
      productName: productName ?? this.productName,
    );
  }

}