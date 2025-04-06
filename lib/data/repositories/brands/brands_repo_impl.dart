import 'package:catalogat_app/data/models/models.dart';
import 'package:catalogat_app/core/helpers/resource.dart';
import 'package:catalogat_app/domain/entities/brand_entity.dart';
import 'package:catalogat_app/data/sources/supabase_service.dart';
import 'package:catalogat_app/domain/repositories/repositories.dart';

class BrandsRepoImpl extends BrandsRepo {

  final SupabaseService _supabaseService;
  BrandsRepoImpl(this._supabaseService);

  @override
  Future<Resource<BrandEntity>> addBrand(AddBrandParams brandRequest) async {
    try {
      final response = await _supabaseService.addBrand(brandRequest);
      return response.toResource((data) => data.toEntity());
    } catch (e) {
      return Resource.failure("Failed to add brand");
    }
  }

  @override
  Future<Resource<BrandEntity>> deleteBrand(String brandId) async{
    try {
      final response = await _supabaseService.deleteBrand(DeleteBrandParams(brandId: brandId));
      return response.toResource((data) => data.toEntity());
    } catch (e) {
      return Resource.failure("Failed to delete brand");
    }
  }

  @override
  Future<Resource<List<BrandEntity>>> getBrands() async{
    try {
      final response = await _supabaseService.getBrandsWithProducts();
      return response.toResource((data) => data.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Resource.failure("Failed to fetch brands");
    }
  }

  @override
  Future<Resource<BrandEntity>> updateBrand(UpdateBrandParams updateBrandParams) async{
    try {
      final response = await _supabaseService.updateBrand(updateBrandParams);
      return response.toResource((data) => data.toEntity());
    } catch (e) {
      return Resource.failure("Failed to update brand");
    }
  }
}