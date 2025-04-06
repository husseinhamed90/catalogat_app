import 'package:catalogat_app/core/dependencies.dart';

part 'add_brand_params.g.dart';

@JsonSerializable()
class AddBrandParams {
  String? name;
  String? logo;

  AddBrandParams({this.name, this.logo});

  factory AddBrandParams.fromJson(Map<String, dynamic> json) => _$AddBrandParamsFromJson(json);

  Map<String, dynamic> toJson() => _$AddBrandParamsToJson(this);

  AddBrandParams copyWith({
    String? name,
    String? logo,
  }) {
    return AddBrandParams(
      name: name ?? this.name,
      logo: logo ?? this.logo,
    );
  }
}