import 'package:catalogat_app/data/models/models.dart';
import 'package:catalogat_app/core/helpers/resource.dart';
import 'package:catalogat_app/domain/entities/entities.dart';

abstract class ProductsRepo {
  Future<Resource<List<ProductEntity>>> getProductsByBrand(String brandId);
  Future<Resource<bool>> addProduct(ProductModel product);
  Future<Resource<bool>> updateProduct(ProductModel product);
  Future<Resource<bool>> deleteProduct(String productId, String brandId);
}