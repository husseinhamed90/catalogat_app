import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/data/models/models.dart';
import 'package:catalogat_app/domain/entities/entities.dart';

abstract class BrandsRepo {
  Future<Resource<List<BrandEntity>>> getBrands();
  Future<Resource<bool>> addBrand(BrandModel brand);
  Future<Resource<bool>> updateBrand(BrandModel brand);
  Future<Resource<bool>> deleteBrand(String brandId);
}