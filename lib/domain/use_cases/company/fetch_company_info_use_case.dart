import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/domain/entities/entities.dart';
import 'package:catalogat_app/domain/repositories/repositories.dart';

class FetchCompanyInfoUseCase {
  final CompanyRepository _repository;

  FetchCompanyInfoUseCase(this._repository);

  Future<Resource<CompanyEntity>> call() async {
    return await _repository.getCompany();
  }
}