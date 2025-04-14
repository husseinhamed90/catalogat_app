import 'package:catalogat_app/core/dependencies.dart';

class CompanyEntity extends Equatable {
  final String name;
  final String logoUrl;
  final String representativeName;

  const CompanyEntity({
    this.name = '',
    this.logoUrl = '',
    this.representativeName = '',
  });

  bool get isDataValid {
    return name.isNotEmpty && representativeName.isNotEmpty;
  }

  @override
  List<Object> get props => [
    name,
    logoUrl,
    representativeName,
  ];

  CompanyEntity copyWith({
    String? name,
    String? logoUrl,
    String? representativeName,
  }) {
    return CompanyEntity(
      name: name ?? this.name,
      logoUrl: logoUrl ?? this.logoUrl,
      representativeName: representativeName ?? this.representativeName,
    );
  }
}