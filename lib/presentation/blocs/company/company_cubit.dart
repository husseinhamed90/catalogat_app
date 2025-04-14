
import 'dart:io';

import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/data/models/models.dart';
import 'package:catalogat_app/domain/entities/entities.dart';
import 'package:catalogat_app/domain/use_cases/use_cases.dart';

part 'company_state.dart';

class CompanyCubit extends Cubit<CompanyState> {
  CompanyCubit(this._uploadFileToStorageUseCase, this._fetchCompanyInfoUseCase, this._updateCompanyInfoUseCase) : super(CompanyState()){
    getCompany();
  }

  final FetchCompanyInfoUseCase _fetchCompanyInfoUseCase;
  final UpdateCompanyInfoUseCase _updateCompanyInfoUseCase;
  final UploadFileToStorageUseCase _uploadFileToStorageUseCase;

  void updateCompanyName(String name) {
    emit(state.copyWith(companyName: name));
  }

  void updateCompanyRepresentative(String representativeName) {
    emit(state.copyWith(companyRepresentativeName: representativeName));
  }

  void updateLogoFile(File? logoFile) {
    emit(state.copyWith(logoFile: Optional(logoFile)));
  }

  Future<void> getCompany() async {
    emit(state.copyWith(companyResource: Resource.loading()));
    final companyResource = await _fetchCompanyInfoUseCase();
    if (companyResource.isSuccess) {
      emit(state.copyWith(
        logoFile: null,
        company: companyResource.data,
        companyRepresentativeName: companyResource.data?.representativeName,
        companyName: companyResource.data?.name,
      ));
    } else {
      emit(state.copyWith(companyResource: Resource.failure(companyResource.message ?? "")));
    }
  }

  Future<bool> saveCompany() async {
    emit(state.copyWith(saveCompanyResource: Resource.loading()));
    CompanyEntity company = CompanyEntity(
      name: state.companyName,
      logoUrl: state.company?.logoUrl ?? "",
      representativeName: state.companyRepresentativeName,
    );
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
    final Resource<CompanyEntity> companyResource = await _updateCompanyInfoUseCase(UpdateCompanyInfoParams(
      companyName: state.companyName,
      representativeName: state.companyRepresentativeName,
      logoUrl: company.logoUrl,
    ));
    emit(state.copyWith(
        logoFile: Optional(null),
        company: company.copyWith(logoUrl: company.logoUrl),
        saveCompanyResource: companyResource
    ));
    return companyResource.isSuccess;
  }
}
