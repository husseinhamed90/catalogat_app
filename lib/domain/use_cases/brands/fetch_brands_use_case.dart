import 'package:catalogat_app/core/helpers/resource.dart';
import 'package:catalogat_app/domain/entities/entities.dart';
import 'package:catalogat_app/domain/repositories/brands/brands_repo.dart';

class FetchBrandsUseCase {
  final BrandsRepo _brandsRepository;

  FetchBrandsUseCase(this._brandsRepository);

  Future<Resource<List<BrandEntity>>> call() async {
    return await _brandsRepository.getBrands();
  }
}