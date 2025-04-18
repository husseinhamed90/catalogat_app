import 'package:catalogat_app/core/helpers/resource.dart';
import 'package:catalogat_app/data/models/batch_of_products_positions_model.dart';
import 'package:catalogat_app/domain/repositories/brands/brands_repo.dart';

class ReorderBrandProductsUseCase {
  final BrandsRepo _brandRepository;

  ReorderBrandProductsUseCase(this._brandRepository);

  Future<Resource<bool>> call(List<OrderedProduct> products) async {
    return await _brandRepository.reorderBrandProducts(products);
  }
}