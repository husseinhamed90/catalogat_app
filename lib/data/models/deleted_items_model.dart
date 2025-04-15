import 'package:catalogat_app/core/dependencies.dart';

part 'deleted_items_model.g.dart';

@JsonSerializable()
class DeletedItemsModel implements EntityConverter<DeletedItemsModel,int> {
  @JsonKey(name: 'deleted_count')
  final int? deletedItemsCount;

  DeletedItemsModel({
    this.deletedItemsCount,
  });

  factory DeletedItemsModel.fromJson(Map<String, dynamic> json) =>
      _$DeletedItemsModelFromJson(json);

  Map<String, dynamic> toJson() => _$DeletedItemsModelToJson(this);

  @override
  int toEntity() {
    return deletedItemsCount ?? 0;
  }

}