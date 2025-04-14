import 'package:catalogat_app/core/helpers/resource.dart';
import 'package:catalogat_app/data/models/models.dart';
import 'package:catalogat_app/domain/entities/entities.dart';
import 'package:catalogat_app/domain/repositories/repositories.dart';

class UpdateCompanyInfoUseCase {
  final CompanyRepository _companyRepository;

  UpdateCompanyInfoUseCase(this._companyRepository);

  Future<Resource<CompanyEntity>> call(UpdateCompanyInfoParams company) async {
    return await _companyRepository.updateCompany(company);
  }
}