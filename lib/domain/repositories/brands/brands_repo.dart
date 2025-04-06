import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/data/models/models.dart';
import 'package:catalogat_app/domain/entities/entities.dart';

abstract class BrandsRepo {
  Future<Resource<List<BrandEntity>>> getBrands();
  Future<Resource<BrandEntity>> addBrand(AddBrandParams brandRequest);
  Future<Resource<BrandEntity>> updateBrand(UpdateBrandParams updateBrandParams);
  Future<Resource<BrandEntity>> deleteBrand(String brandId);
}