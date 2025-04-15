// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_items_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteItemsRequest _$DeleteItemsRequestFromJson(Map<String, dynamic> json) =>
    DeleteItemsRequest(
      ids: (json['ids'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$DeleteItemsRequestToJson(DeleteItemsRequest instance) =>
    <String, dynamic>{'ids': instance.ids};
