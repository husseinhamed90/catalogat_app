import 'package:catalogat_app/core/helpers/resource.dart';
import 'package:catalogat_app/domain/entities/entities.dart';
import 'package:catalogat_app/domain/repositories/repositories.dart';

class UpdateProductUseCase {
  final ProductsRepo _productsRepository;

  UpdateProductUseCase(this._productsRepository);

  Future<Resource<bool>> call(ProductEntity product) async {
    return await _productsRepository.updateProduct(product.toModel);
  }
}