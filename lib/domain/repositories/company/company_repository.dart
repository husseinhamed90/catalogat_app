import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/data/models/models.dart';
import 'package:catalogat_app/domain/entities/entities.dart';

abstract class CompanyRepository {
  Future<Resource<CompanyEntity>> getCompany();
  Future<Resource<CompanyEntity>> updateCompany(UpdateCompanyInfoParams company);
}