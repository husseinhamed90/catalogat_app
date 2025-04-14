import 'package:catalogat_app/core/helpers/resource.dart';
import 'package:catalogat_app/data/models/models.dart';
import 'package:catalogat_app/domain/entities/entities.dart';
import 'package:catalogat_app/domain/repositories/repositories.dart';

class UpdateBrandUseCase {
  final BrandsRepo _brandsRepository;

  UpdateBrandUseCase(this._brandsRepository);

  Future<Resource<BrandEntity>> call(UpdateBrandParams updateBrandParams) async {
    return await _brandsRepository.updateBrand(updateBrandParams);
  }
}