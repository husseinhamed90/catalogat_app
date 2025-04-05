import 'package:catalogat_app/core/helpers/resource.dart';
import 'package:catalogat_app/domain/entities/entities.dart';
import 'package:catalogat_app/domain/repositories/repositories.dart';

class FetchBrandProductsUseCase {
  final ProductsRepo _productsRepository;

  FetchBrandProductsUseCase(this._productsRepository);

  Future<Resource<List<ProductEntity>>> call(String brandId) async {
    return await _productsRepository.getProductsByBrand(brandId);
  }
}