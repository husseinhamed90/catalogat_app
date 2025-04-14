import 'package:catalogat_app/core/dependencies.dart';

import 'product_cart_item.dart';

part 'create_order_params.g.dart';

@JsonSerializable()
class CreateOrderParams {

  @JsonKey(name: 'company_name')
  final String? companyName;
  @JsonKey(name: 'representative_name')
  final String? representativeName;
  @JsonKey(name: 'customer_name')
  final String? customerName;
  @JsonKey(name: 'total_price')
  final double? totalPrice;
  final List<ProductCartItem> products;


  CreateOrderParams({
    this.totalPrice,
    this.companyName,
    this.customerName,
    this.representativeName,
    this.products = const [],
  });

  factory CreateOrderParams.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderParamsFromJson(json);

  Map<String, dynamic> toJson() => _$CreateOrderParamsToJson(this);

  CreateOrderParams copyWith({
    String? companyName,
    String? representativeName,
    String? customerName,
    double? totalPrice,
    List<ProductCartItem>? products,
  }) {
    return CreateOrderParams(
      companyName: companyName ?? this.companyName,
      representativeName: representativeName ?? this.representativeName,
      customerName: customerName ?? this.customerName,
      totalPrice: totalPrice ?? this.totalPrice,
      products: products ?? this.products,
    );
  }
}