import 'package:catalogat_app/core/helpers/resource.dart';
import 'package:catalogat_app/data/models/models.dart';
import 'package:catalogat_app/domain/entities/entities.dart';
import 'package:catalogat_app/domain/repositories/repositories.dart';

class AddProductUseCase {
  final ProductsRepo _productsRepository;

  AddProductUseCase(this._productsRepository);

  Future<Resource<ProductEntity>> call(AddProductParams addProductParams) async {
    return await _productsRepository.addProduct(addProductParams);
  }
}