// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_brand_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateBrandParams _$UpdateBrandParamsFromJson(Map<String, dynamic> json) =>
    UpdateBrandParams(
      id: json['p_current_brand_id'] as String,
      name: json['p_new_name'] as String,
      imageUrl: json['p_new_image'] as String?,
    );

Map<String, dynamic> _$UpdateBrandParamsToJson(UpdateBrandParams instance) =>
    <String, dynamic>{
      'p_current_brand_id': instance.id,
      'p_new_name': instance.name,
      'p_new_image': instance.imageUrl,
    };
