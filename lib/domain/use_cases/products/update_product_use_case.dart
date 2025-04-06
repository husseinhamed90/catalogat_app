import 'package:catalogat_app/core/helpers/resource.dart';
import 'package:catalogat_app/data/models/models.dart';
import 'package:catalogat_app/domain/entities/entities.dart';
import 'package:catalogat_app/domain/repositories/repositories.dart';

class UpdateProductUseCase {
  final ProductsRepo _productsRepository;

  UpdateProductUseCase(this._productsRepository);

  Future<Resource<ProductEntity>> call(UpdateProductParams updateProductParams) async {
    return await _productsRepository.updateProduct(updateProductParams);
  }
}