import 'package:catalogat_app/core/helpers/resource.dart';
import 'package:catalogat_app/data/models/models.dart';
import 'package:catalogat_app/data/sources/supabase_service.dart';
import 'package:catalogat_app/domain/entities/entities.dart';
import 'package:catalogat_app/domain/repositories/repositories.dart';

class CompanyRepositoryImpl implements CompanyRepository {
  final SupabaseService _supabaseService;
  
  CompanyRepositoryImpl(this._supabaseService);

  @override
  Future<Resource<CompanyEntity>> getCompany() async{
    //try {
      final response = await _supabaseService.getCompany();
      return response.toResource((data) => data.toEntity());
    // } catch (e) {
    //   return Resource.failure("Error fetching company data");
    // }
  }

  @override
  Future<Resource<CompanyEntity>> updateCompany(UpdateCompanyInfoParams company) async{
    try {
      final response = await _supabaseService.updateCompanyInfo(company);
      return response.toResource((data) => data.toEntity());
    } catch (e) {
      return Resource.failure("Error updating company data");
    }
  }
}