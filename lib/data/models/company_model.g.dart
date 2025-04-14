// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompanyModel _$CompanyModelFromJson(Map<String, dynamic> json) => CompanyModel(
  name: json['company_name'] as String? ?? '',
  logoUrl: json['logo_url'] as String? ?? '',
  representativeName: json['representative_name'] as String? ?? '',
);

Map<String, dynamic> _$CompanyModelToJson(CompanyModel instance) =>
    <String, dynamic>{
      'company_name': instance.name,
      'logo_url': instance.logoUrl,
      'representative_name': instance.representativeName,
    };
