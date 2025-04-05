import 'package:catalogat_app/core/helpers/resource.dart';
import 'package:catalogat_app/domain/entities/entities.dart';
import 'package:catalogat_app/domain/repositories/repositories.dart';

class AddBrandUseCase {
  final BrandsRepo _brandsRepository;

  AddBrandUseCase(this._brandsRepository);

  Future<Resource<bool>> call(BrandEntity brand) async {
    return await _brandsRepository.addBrand(brand.toModel);
  }
}