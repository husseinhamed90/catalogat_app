import 'package:catalogat_app/core/dependencies.dart';

part 'create_customer_params.g.dart';

@JsonSerializable()
class CreateCustomerParams {
  String? name;

  CreateCustomerParams({
    this.name,
  });

  factory CreateCustomerParams.fromJson(Map<String, dynamic> json) =>
      _$CreateCustomerParamsFromJson(json);

  Map<String, dynamic> toJson() => _$CreateCustomerParamsToJson(this);
}