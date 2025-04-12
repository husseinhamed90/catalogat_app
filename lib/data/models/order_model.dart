import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/domain/entities/entities.dart';


part 'order_model.g.dart';

@JsonSerializable()
class OrderModel extends EntityConverter<OrderModel, OrderEntity> {

  @JsonKey(name: 'product_code')
  final String? productCode;
  @JsonKey(name: 'product_name')
  final String? productName;
  final int? quantity;
  @JsonKey(name: 'total_price')
  final double? totalPrice;

  OrderModel({
    this.productCode,
    this.productName,
    this.quantity,
    this.totalPrice,
  });


  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);

  @override
  OrderEntity toEntity() {
    return OrderEntity(
      productCode: productCode ?? '',
      productName: productName ?? '',
      quantity: quantity ?? 0,
      totalPrice: totalPrice ?? 0.0,
    );
  }
}