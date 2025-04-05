import 'package:catalogat_app/core/helpers/resource.dart';
import 'package:catalogat_app/domain/repositories/brands/brands_repo.dart';

class DeleteBrandUseCase {
  final BrandsRepo _brandsRepository;

  DeleteBrandUseCase(this._brandsRepository);

  Future<Resource<bool>> call(String brandId) async {
    return await _brandsRepository.deleteBrand(brandId);
  }
}