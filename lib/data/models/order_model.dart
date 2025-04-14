import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/data/models/models.dart';
import 'package:catalogat_app/domain/entities/entities.dart';

part 'order_model.g.dart';

@JsonSerializable()
class OrderModel extends EntityConverter<OrderModel, OrderEntity> {

  @JsonKey(name: 'customer_id')
  final String? customerId;
  @JsonKey(name: 'total_price')
  final double? totalPrice;
  @JsonKey(name: 'company_name')
  final String? companyName;
  @JsonKey(name: 'representative_name')
  final String? representativeName;
  @JsonKey(name: 'customer_name')
  final String? customerName;
  final DateTime? createdAt;
  final List<ProductCartItem>? products;

  OrderModel({
    this.customerId,
    this.totalPrice,
    this.companyName,
    this.representativeName,
    this.customerName,
    this.createdAt,
    this.products,
  });


  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);

  @override
  OrderEntity toEntity() {
    return OrderEntity(
      customerId: customerId,
      totalPrice: totalPrice ?? 0.0,
      companyName: companyName ?? "",
      customerName: customerName ?? "",
      createdAt: createdAt ?? DateTime.now(),
      representativeName: representativeName ?? "",
      products: products?.map((e) => e.toEntity()).toList() ?? [],
    );
  }
}