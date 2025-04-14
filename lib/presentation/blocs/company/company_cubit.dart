
import 'dart:io';

import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/domain/entities/entities.dart';
import 'package:catalogat_app/domain/use_cases/upload_file_to_storage_use_case.dart';

part 'company_state.dart';

class CompanyCubit extends Cubit<CompanyState> {
  CompanyCubit(this._uploadFileToStorageUseCase) : super(CompanyState()){
    getCompany();
  }

  final UploadFileToStorageUseCase _uploadFileToStorageUseCase;

  void updateCompanyName(String name) {
    emit(state.copyWith(companyName: name));
  }

  void updateCompanyRepresentative(String representativeName) {
    emit(state.copyWith(companyRepresentativeName: representativeName));
  }

  void updateLogoFile(File? logoFile) {
    emit(state.copyWith(logoFile: logoFile));
  }

  Future<void> getCompany() async {

  }

  Future<bool> saveCompany() async {
    emit(state.copyWith(saveCompanyResource: Resource.loading()));
    CompanyEntity company = CompanyEntity(
      name: state.companyName,
      representativeName: state.companyRepresentativeName,
    );
    print("company name: ${company.name}");
    print("company representative name: ${company.representativeName}");
    if(state.logoFile != null) {
      final Resource<String> uploadFileResource = await _uploadFileToStorageUseCase(
        state.logoFile?.path ?? "",
      );
      if (uploadFileResource.isSuccess) {
        company = company.copyWith(logoUrl: uploadFileResource.data);
      } else {
        emit(state.copyWith(saveCompanyResource: Resource.failure(uploadFileResource.message ?? "",)));
        return false;
      }
    }
    await Future.delayed(const Duration(seconds: 2));
    print("-- Company info saved --");
    print("Company name: ${company.name}");
    print("Company representative name: ${company.representativeName}");
    print("Company logo url: ${company.logoUrl}");
    emit(state.copyWith(
        company: company.copyWith(logoUrl: company.logoUrl),
        saveCompanyResource: Resource.success(company))
    );
    return true;
  }
}
