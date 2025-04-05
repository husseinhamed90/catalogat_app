import 'package:catalogat_app/core/helpers/resource.dart';
import 'package:catalogat_app/domain/entities/brand_entity.dart';
import 'package:catalogat_app/domain/repositories/brands/brands_repo.dart';

class UpdateBrandUseCase {
  final BrandsRepo _brandsRepository;

  UpdateBrandUseCase(this._brandsRepository);

  Future<Resource<bool>> call(BrandEntity brand) async {
    return await _brandsRepository.updateBrand(brand.toModel);
  }
}