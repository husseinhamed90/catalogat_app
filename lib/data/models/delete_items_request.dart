import 'package:catalogat_app/core/dependencies.dart';

part 'delete_items_request.g.dart';

@JsonSerializable()
class DeleteItemsRequest {
  final List<String> ids;

  DeleteItemsRequest({required this.ids});

  factory DeleteItemsRequest.fromJson(Map<String, dynamic> json) =>
      _$DeleteItemsRequestFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteItemsRequestToJson(this);
}