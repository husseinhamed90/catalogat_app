import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/domain/entities/order/customer_entity.dart';

part 'customer_model.g.dart';

@JsonSerializable()
class CustomerModel implements EntityConverter<CustomerModel, CustomerEntity> {
  String? id;
  String? name;

  CustomerModel({
    this.id,
    this.name,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerModelFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerModelToJson(this);

  @override
  CustomerEntity toEntity() {
    return CustomerEntity(
      id: id,
      name: name ?? ""
    );
  }

}