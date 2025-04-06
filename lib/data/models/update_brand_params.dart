import 'package:catalogat_app/core/dependencies.dart';

part 'update_brand_params.g.dart';

@JsonSerializable()
class UpdateBrandParams {

  @JsonKey(name: 'p_current_brand_id')
  final String id;
  @JsonKey(name: 'p_new_name')
  final String name;
  @JsonKey(name: 'p_new_image')
  final String? imageUrl;

  UpdateBrandParams({
    required this.id,
    required this.name,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() => _$UpdateBrandParamsToJson(this);

  UpdateBrandParams copyWith({
    String? id,
    String? name,
    String? imageUrl,
  }) {
    return UpdateBrandParams(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}