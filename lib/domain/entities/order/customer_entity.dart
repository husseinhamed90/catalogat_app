import 'package:catalogat_app/core/dependencies.dart';

class CustomerEntity extends Equatable {
  final String? id;
  final String name;

  const CustomerEntity({
    this.id,
    this.name = '',
  });

  @override
  List<Object?> get props => [id, name];
}