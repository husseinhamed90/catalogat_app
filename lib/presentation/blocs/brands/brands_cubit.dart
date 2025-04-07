import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/data/models/models.dart';
import 'package:catalogat_app/domain/entities/entities.dart';
import 'package:catalogat_app/domain/use_cases/use_cases.dart';
import 'package:image_picker/image_picker.dart';

part 'brands_state.dart';

class BrandsCubit extends Cubit<BrandsState> {
  BrandsCubit(this._addBrandUseCase, this._deleteBrandUseCase, this._updateBrandUseCase, this._fetchBrandsUseCase, this._addProductUseCase, this._updateProductUseCase, this._deleteProductUseCase, this._uploadFileToStorageUseCase) : super(BrandsState());

  final AddBrandUseCase _addBrandUseCase;
  final DeleteBrandUseCase _deleteBrandUseCase;
  final UpdateBrandUseCase _updateBrandUseCase;
  final FetchBrandsUseCase _fetchBrandsUseCase;
  final AddProductUseCase _addProductUseCase;
  final UpdateProductUseCase _updateProductUseCase;
  final DeleteProductUseCase _deleteProductUseCase;
  final UploadFileToStorageUseCase _uploadFileToStorageUseCase;


  Future<void> getBrands([bool loading = true]) async {
    if (loading) emit(state.copyWith(brandsResource: Resource.loading()));
    final resource = await _fetchBrandsUseCase.call();
    emit(state.copyWith(brandsResource: resource));
  }

  Future<(bool,String?)> addBrand({required AddBrandParams requestModel}) async {
    emit(state.copyWith(addBrandResource: Resource.loading()));
    if (state.imageFile != null) {
      final Resource<String>? uploadFileResource = await _uploadFileToStorageUseCase(
        state.imageFile?.path ?? "",
      );
      if (uploadFileResource != null && uploadFileResource.isSuccess) {
        requestModel = requestModel.copyWith(logo: uploadFileResource.data);
      }
    }
    final resource = await _addBrandUseCase(requestModel);
    emit(state.copyWith(addBrandResource: resource));
    return (resource.isSuccess, resource.message);
  }

  Future<(bool,String?)> updateBrand(UpdateBrandParams updateBrandParams) async {
    emit(state.copyWith(updateBrandResource: Resource.loading()));
    if (state.imageFile != null) {
      final Resource<String>? uploadFileResource = await _uploadFileToStorageUseCase(
        state.imageFile?.path ?? "",
      );
      if (uploadFileResource != null && uploadFileResource.isSuccess) {
        updateBrandParams = updateBrandParams.copyWith(imageUrl: uploadFileResource.data);
      }
    }
    final resource = await _updateBrandUseCase(updateBrandParams);
    emit(state.copyWith(updateBrandResource: resource));
    return (resource.isSuccess, resource.message);
  }

  Future<(bool,String?)> deleteBrand(String brandId) async {
    final brands = state.brandsResource.data;
    final updatedBrands = brands?.where((brand) => brand.id != brandId).toList();
    emit(state.copyWith(
        deleteBrandResource: Resource.loading(),
        brandsResource: Resource.success(updatedBrands ?? []),
    ));
    final resource = await _deleteBrandUseCase(brandId);
    if (resource.isSuccess) {
      emit(state.copyWith(deleteBrandResource: resource));
    } else {
      emit(state.copyWith(
          deleteBrandResource: resource,
          brandsResource: Resource.success(brands ?? []),
      ));
    }
    return (resource.isSuccess, resource.message ?? "Failed to delete brand");
  }

  void setFileImage(XFile? file) {
    emit(state.copyWith(imageFile: Optional(file)));
  }

  void selectedBrand(BrandEntity? currentBrand) {
    emit(state.copyWith(selectedBrand: Optional(currentBrand)));
  }

  Future<(bool,String)> addProduct({required AddProductParams addProductParams}) async {
    emit(state.copyWith(addProductResource: Resource.loading()));
    if (state.imageFile != null) {
      final Resource<String>? uploadFileResource = await _uploadFileToStorageUseCase(
        state.imageFile?.path ?? "",
      );
      if (uploadFileResource != null && uploadFileResource.isSuccess) {
        addProductParams = addProductParams.copyWith(productImage: uploadFileResource.data);
      }
    }
    final Resource<ProductEntity> addProductResource = await _addProductUseCase(addProductParams);
    emit(state.copyWith(addProductResource: addProductResource));
    return (addProductResource.isSuccess, addProductResource.message ?? "Failed to add product");
  }

  Future<(bool,String?)> updateProduct({required UpdateProductParams updateProductParams}) async {
    emit(state.copyWith(updateProductResource: Resource.loading()));
    if (state.imageFile != null) {
      final Resource<String>? uploadFileResource = await _uploadFileToStorageUseCase(
        state.imageFile?.path ?? "",
      );
      if (uploadFileResource != null && uploadFileResource.isSuccess) {
        updateProductParams = updateProductParams.copyWith(imageUrl: uploadFileResource.data);
      }
    }
    final Resource<ProductEntity> updateProductResource = await _updateProductUseCase(updateProductParams);
    emit(state.copyWith(updateProductResource: updateProductResource));
    return (updateProductResource.isSuccess, updateProductResource.message);
  }

  Future<(bool,String?)> deleteProduct({required String productId,required String currentBrandId}) async {
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
    final Resource<bool> deleteProductResource = await _deleteProductUseCase(productId);
    if(!deleteProductResource.isSuccess) {
      emit(state.copyWith(
        deleteProductResource: Resource.failure(deleteProductResource.message ?? ""),
        brandsResource: Resource.success(brands ?? []),
      ));
    }
    return (deleteProductResource.isSuccess, deleteProductResource.message);
  }

  void resetState() {
    emit(state.copyWith(
      imageFile: Optional(null),
      selectedBrand: Optional(null),
    ));
  }

  void setProductName(String name) {
    emit(state.copyWith(productName: name));
  }

  void setProductPrice1(String price) {
    emit(state.copyWith(productPrice1: price));
  }

  void setProductPrice2(String price) {
    emit(state.copyWith(productPrice2: price));
  }
}
