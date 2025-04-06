import 'package:catalogat_app/data/models/models.dart';
import 'package:catalogat_app/core/helpers/resource.dart';
import 'package:catalogat_app/domain/entities/entities.dart';

abstract class ProductsRepo {
  Future<Resource<ProductEntity>> addProduct(AddProductParams product);
  Future<Resource<ProductEntity>> updateProduct(UpdateProductParams updateProductParams);
  Future<Resource<bool>> deleteProduct(String productId);
}