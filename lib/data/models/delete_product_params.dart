import 'package:catalogat_app/core/dependencies.dart';

part 'delete_product_params.g.dart';

@JsonSerializable()
class DeleteProductParams {
  @JsonKey(name: 'product_id')
  final String productId;

  DeleteProductParams({required this.productId});

  Map<String, dynamic> toJson() => _$DeleteProductParamsToJson(this);
}