import 'package:catalogat_app/core/dependencies.dart';

part 'delete_brand_params.g.dart';

@JsonSerializable()
class DeleteBrandParams {
  @JsonKey(name: 'brand_id')
  final String brandId;

  DeleteBrandParams({required this.brandId});

  Map<String, dynamic> toJson() => _$DeleteBrandParamsToJson(this);
}