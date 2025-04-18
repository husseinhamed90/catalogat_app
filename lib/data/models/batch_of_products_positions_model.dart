import 'package:catalogat_app/core/dependencies.dart';

part 'batch_of_products_positions_model.g.dart';

@JsonSerializable()
class BatchOfProductsPositionsModel {
  final List<OrderedProduct> products;

  BatchOfProductsPositionsModel({
    required this.products,
  });

  factory BatchOfProductsPositionsModel.fromJson(Map<String, dynamic> json) =>
      _$BatchOfProductsPositionsModelFromJson(json);

  Map<String, dynamic> toJson() => _$BatchOfProductsPositionsModelToJson(this);
}

@JsonSerializable()
class OrderedProduct {
  final String id;
  final int position;

  OrderedProduct({
    required this.id,
    required this.position,
  });

  factory OrderedProduct.fromJson(Map<String, dynamic> json) =>
      _$OrderedProductFromJson(json);

  Map<String, dynamic> toJson() => _$OrderedProductToJson(this);
}