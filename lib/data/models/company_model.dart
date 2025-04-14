import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/domain/entities/company/company_entity.dart';

part 'company_model.g.dart';

@JsonSerializable()
class CompanyModel implements EntityConverter<CompanyModel, CompanyEntity> {
  @JsonKey(name: 'company_name')
  final String name;
  @JsonKey(name: 'logo_url')
  final String logoUrl;
  @JsonKey(name: 'representative_name')
  final String representativeName;

  const CompanyModel({
    this.name = '',
    this.logoUrl = '',
    this.representativeName = '',
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) =>
      _$CompanyModelFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyModelToJson(this);

  @override
  CompanyEntity toEntity() {
    return CompanyEntity(
      name: name,
      logoUrl: logoUrl,
      representativeName: representativeName,
    );
  }
}