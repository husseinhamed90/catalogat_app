// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_company_info_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateCompanyInfoParams _$UpdateCompanyInfoParamsFromJson(
  Map<String, dynamic> json,
) => UpdateCompanyInfoParams(
  companyName: json['company_name'] as String?,
  representativeName: json['representative_name'] as String?,
  logoUrl: json['logo_url'] as String?,
);

Map<String, dynamic> _$UpdateCompanyInfoParamsToJson(
  UpdateCompanyInfoParams instance,
) => <String, dynamic>{
  'company_name': instance.companyName,
  'representative_name': instance.representativeName,
  'logo_url': instance.logoUrl,
};
