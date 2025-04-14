import 'package:catalogat_app/core/dependencies.dart';

part 'add_customer_params.g.dart';

@JsonSerializable()
class AddCustomerParams {

  @JsonKey(name: 'customer_name')
  final String customerName;

  const AddCustomerParams({
    required this.customerName,
  });

  factory AddCustomerParams.fromJson(Map<String, dynamic> json) =>
      _$AddCustomerParamsFromJson(json);

  Map<String, dynamic> toJson() => _$AddCustomerParamsToJson(this);
}