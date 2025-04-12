import 'package:catalogat_app/core/dependencies.dart';

part 'create_order_params.g.dart';

@JsonSerializable()
class CreateOrderParams {
  @JsonKey(name: 'product_code')
  final String? productCode;
  @JsonKey(name: 'product_name')
  final String? productName;
  final int? quantity;
  @JsonKey(name: 'total_price')
  final double? totalPrice;


  CreateOrderParams({
    this.productCode,
    this.productName,
    this.quantity,
    this.totalPrice,
  });

  factory CreateOrderParams.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderParamsFromJson(json);

  Map<String, dynamic> toJson() => _$CreateOrderParamsToJson(this);
}