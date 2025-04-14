import 'package:catalogat_app/core/dependencies.dart';

part 'update_company_info_params.g.dart';

@JsonSerializable()
class UpdateCompanyInfoParams {
  @JsonKey(name: 'company_name')
  final String? companyName;
  @JsonKey(name: 'representative_name')
  final String? representativeName;
  @JsonKey(name: 'logo_url')
  final String? logoUrl;

  UpdateCompanyInfoParams({
    this.companyName,
    this.representativeName,
    this.logoUrl,
  });

  factory UpdateCompanyInfoParams.fromJson(Map<String, dynamic> json) =>
      _$UpdateCompanyInfoParamsFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateCompanyInfoParamsToJson(this);
}