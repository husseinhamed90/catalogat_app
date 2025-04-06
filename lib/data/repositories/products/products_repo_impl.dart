import 'package:catalogat_app/core/helpers/resource.dart';
import 'package:catalogat_app/data/models/models.dart';
import 'package:catalogat_app/data/sources/supabase_service.dart';
import 'package:catalogat_app/domain/entities/entities.dart';
import 'package:catalogat_app/domain/repositories/repositories.dart';

class ProductsRepoImpl implements ProductsRepo {

  final SupabaseService _supabaseService;

  ProductsRepoImpl(this._supabaseService);

  @override
  Future<Resource<ProductEntity>> addProduct(AddProductParams addProductParams) async{
    try {
      final apiResponse = await _supabaseService.addProduct(addProductParams);
      return apiResponse.toResource((data) => data.toEntity());
    } catch (e) {
      return Resource.failure("Failed to add product");
    }
  }

  @override
  Future<Resource<bool>> deleteProduct(String productId) async {
    try {
      final apiResponse = await _supabaseService.deleteProduct(DeleteProductParams(productId: productId));
      if(apiResponse.toResource().isSuccess) {
        return Resource.success(true);
      }
      return Resource.failure(apiResponse.toResource().message ?? "Failed to delete product");
    } catch (e) {
      return Resource.failure("Failed to delete product");
    }
  }

  @override
  Future<Resource<ProductEntity>> updateProduct(UpdateProductParams updateProductParams) async {
    try {
      final apiResponse = await _supabaseService.updateProduct(updateProductParams);
      return apiResponse.toResource((data) => data.toEntity());
    } catch (e) {
      return Resource.failure("Failed to update product");
    }
  }
}