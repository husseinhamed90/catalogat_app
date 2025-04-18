import 'package:catalogat_app/core/dependencies.dart';

part 'updated_product_positions_model.g.dart';

@JsonSerializable()
class UpdatedProductPositionsModel {
  @JsonKey(name: 'updated_count')
  final int? updatedItemsCount;

  UpdatedProductPositionsModel({
    this.updatedItemsCount,
  });

  factory UpdatedProductPositionsModel.fromJson(Map<String, dynamic> json) =>
      _$UpdatedProductPositionsModelFromJson(json);

  Map<String, dynamic> toJson() => _$UpdatedProductPositionsModelToJson(this);
}