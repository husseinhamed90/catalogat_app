import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/data/models/add_brand_params.dart';
import 'package:catalogat_app/data/models/update_brand_params.dart';
import 'package:catalogat_app/domain/entities/entities.dart';
import 'package:catalogat_app/domain/use_cases/use_cases.dart';
import 'package:image_picker/image_picker.dart';

part 'brands_state.dart';

class BrandsCubit extends Cubit<BrandsState> {
  BrandsCubit(this._addBrandUseCase, this._deleteBrandUseCase, this._updateBrandUseCase, this._fetchBrandsUseCase, this._addProductUseCase, this._updateProductUseCase, this._deleteProductUseCase, this._fetchBrandProductsUseCase, this._uploadFileToFirebaseStorageUseCase) : super(BrandsState());

  final AddBrandUseCase _addBrandUseCase;
  final DeleteBrandUseCase _deleteBrandUseCase;
  final UpdateBrandUseCase _updateBrandUseCase;
  final FetchBrandsUseCase _fetchBrandsUseCase;
  final AddProductUseCase _addProductUseCase;
  final UpdateProductUseCase _updateProductUseCase;
  final DeleteProductUseCase _deleteProductUseCase;
  final FetchBrandProductsUseCase _fetchBrandProductsUseCase;
  final UploadFileToFirebaseStorageUseCase _uploadFileToFirebaseStorageUseCase;


  Future<void> getBrands([bool loading = true]) async {
    if (loading) emit(state.copyWith(brandsResource: Resource.loading()));
    final resource = await _fetchBrandsUseCase.call();
    emit(state.copyWith(brandsResource: resource));
  }

  Future<bool> addBrand({required AddBrandParams requestModel}) async {
    emit(state.copyWith(addBrandResource: Resource.loading()));
    if (state.imageFile != null) {
      final Resource<String>? uploadFileResource = await _uploadFileToFirebaseStorageUseCase(
        state.imageFile?.path ?? "",
      );
      if (uploadFileResource != null && uploadFileResource.isSuccess) {
        requestModel = requestModel.copyWith(logo: uploadFileResource.data);
      }
    }
    final resource = await _addBrandUseCase(requestModel);
    emit(state.copyWith(addBrandResource: resource));
    return resource.isSuccess;
  }

  Future<bool> updateBrand(UpdateBrandParams updateBrandParams) async {
    emit(state.copyWith(updateBrandResource: Resource.loading()));
    if (state.imageFile != null) {
      final Resource<String>? uploadFileResource = await _uploadFileToFirebaseStorageUseCase(
        state.imageFile?.path ?? "",
      );
      if (uploadFileResource != null && uploadFileResource.isSuccess) {
        updateBrandParams = updateBrandParams.copyWith(imageUrl: uploadFileResource.data);
      }
    }
    final resource = await _updateBrandUseCase(updateBrandParams);
    emit(state.copyWith(updateBrandResource: resource));
    return resource.isSuccess;
  }

  Future<void> deleteBrand(String brandId) async {
    final brands = state.brandsResource.data;
    final updatedBrands = brands?.where((brand) => brand.id != brandId).toList();
    emit(state.copyWith(
        deleteBrandResource: Resource.loading(),
        brandsResource: Resource.success(updatedBrands ?? []),
    ));
    final resource = await _deleteBrandUseCase.call(brandId);
    if (resource.isSuccess) {
      emit(state.copyWith(deleteBrandResource: resource));
    } else {
      emit(state.copyWith(
          deleteBrandResource: resource,
          brandsResource: Resource.success(brands ?? []),
      ));
    }
  }

  void setFileImage(XFile? file) {
    emit(state.copyWith(imageFile: Optional(file)));
  }

  void selectedBrand(BrandEntity? currentBrand) {
    emit(state.copyWith(selectedBrand: Optional(currentBrand)));
  }

  Future<bool> addProduct({required ProductEntity product}) async {
    emit(state.copyWith(addProductResource: Resource.loading()));
    if (state.imageFile != null) {
      final Resource<String>? uploadFileResource = await _uploadFileToFirebaseStorageUseCase(
        state.imageFile?.path ?? "",
      );
      if (uploadFileResource != null && uploadFileResource.isSuccess) {
        product = product.copyWith(imageUrl: uploadFileResource.data);
      }
    }
    final Resource<bool> addProductResource = await _addProductUseCase(product);
    emit(state.copyWith(addProductResource: addProductResource));
    return addProductResource.isSuccess;
  }

  Future<bool> updateProduct({required ProductEntity product}) async {
    emit(state.copyWith(updateProductResource: Resource.loading()));
    final Resource<bool> updateProductResource = await _updateProductUseCase(product);
    emit(state.copyWith(updateProductResource: updateProductResource));
    return updateProductResource.isSuccess;
  }

  Future<bool> deleteProduct({required String productId,required String currentBrandId}) async {
    final brands = state.brandsResource.data;
    final updatedBrands = brands?.map((brand) {
      if (brand.id == currentBrandId) {
        return brand.copyWith(products: brand.products.where((product) => product.id != productId).toList());
      }
      return brand;
    }).toList();
    emit(state.copyWith(
        deleteProductResource: Resource.success(true),
        brandsResource: Resource.success(updatedBrands ?? []),
    ));
    final Resource<bool> deleteProductResource = await _deleteProductUseCase(productId,currentBrandId);
    if(!deleteProductResource.isSuccess) {
      emit(state.copyWith(
        deleteProductResource: Resource.failure(deleteProductResource.message ?? ""),
        brandsResource: Resource.success(brands ?? []),
      ));
    }
    return deleteProductResource.isSuccess;
  }

  void fetchBrandProducts({required String brandId}) async {
    emit(state.copyWith(fetchBrandProductsResource: Resource.loading()));
    final Resource<List<ProductEntity>> fetchBrandProductsResource = await _fetchBrandProductsUseCase(brandId);
    emit(state.copyWith(fetchBrandProductsResource: fetchBrandProductsResource));
  }

  void resetState() {
    emit(state.copyWith(
      imageFile: Optional(null),
      selectedBrand: Optional(null),
    ));
  }
}
