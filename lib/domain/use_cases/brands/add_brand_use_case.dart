import 'package:catalogat_app/core/helpers/resource.dart';
import 'package:catalogat_app/data/models/models.dart';
import 'package:catalogat_app/domain/entities/entities.dart';
import 'package:catalogat_app/domain/repositories/repositories.dart';

class AddBrandUseCase {
  final BrandsRepo _brandsRepository;

  AddBrandUseCase(this._brandsRepository);

  Future<Resource<BrandEntity>> call(AddBrandParams brandRequest) async {
    return await _brandsRepository.addBrand(brandRequest);
  }
}