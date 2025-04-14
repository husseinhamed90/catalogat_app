part of 'company_cubit.dart';

 class CompanyState extends Equatable {

  final File? logoFile;
  final String companyName;
  final CompanyEntity? company;
  final String companyRepresentativeName;
  final Resource<CompanyEntity> companyResource;
  final Resource<CompanyEntity> saveCompanyResource;


  const CompanyState({
    this.company,
    this.logoFile,
    this.companyName = "",
    this.companyRepresentativeName = "",
    this.companyResource = const Resource.initial(),
    this.saveCompanyResource = const Resource.initial(),
  });

  @override
  List<Object?> get props => [
    company,
    logoFile,
    companyName,
    companyResource,
    saveCompanyResource,
    companyRepresentativeName,
  ];

  CompanyState copyWith({
    File? logoFile,
    String? companyName,
    CompanyEntity? company,
    String? companyRepresentativeName,
    Resource<CompanyEntity>? companyResource,
    Resource<CompanyEntity>? saveCompanyResource,
  }) {
    return CompanyState(
      company: company ?? this.company,
      logoFile: logoFile ?? this.logoFile,
      companyName: companyName ?? this.companyName,
      companyResource: companyResource ?? this.companyResource,
      saveCompanyResource: saveCompanyResource ?? this.saveCompanyResource,
      companyRepresentativeName: companyRepresentativeName ?? this.companyRepresentativeName,
    );
  }
}