import 'package:catalogat_app/core/helpers/resource.dart';
import 'package:catalogat_app/domain/repositories/repositories.dart';

class DeleteProductUseCase {
  final ProductsRepo _productsRepository;

  DeleteProductUseCase(this._productsRepository);

  Future<Resource<bool>> call(String productId,String brandId) async {
    return await _productsRepository.deleteProduct(productId,brandId);
  }
}