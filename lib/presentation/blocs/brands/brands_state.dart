part of 'brands_cubit.dart';

class BrandsState extends Equatable {

  final Resource<bool> addBrandResource;
  final Resource<bool> updateBrandResource;
  final Resource<bool> deleteBrandResource;
  final Resource<List<BrandEntity>> brandsResource;
  final BrandEntity? selectedBrand;
  final Resource<bool> addProductResource;
  final Resource<bool> updateProductResource;
  final Resource<bool> deleteProductResource;
  final Resource<List<ProductEntity>> fetchBrandProductsResource;
  final XFile? imageFile;

  const BrandsState({
    this.imageFile,
    this.selectedBrand,
    this.brandsResource = const Resource.initial(),
    this.addBrandResource = const Resource.initial(),
    this.addProductResource = const Resource.initial(),
    this.updateBrandResource = const Resource.initial(),
    this.deleteBrandResource = const Resource.initial(),
    this.deleteProductResource = const Resource.initial(),
    this.updateProductResource = const Resource.initial(),
    this.fetchBrandProductsResource = const Resource.initial(),
  });

  @override
  List<Object?> get props => [
    imageFile,
    selectedBrand,
    brandsResource,
    addBrandResource,
    updateBrandResource,
    deleteBrandResource,
    addProductResource,
    updateProductResource,
    deleteProductResource,
    fetchBrandProductsResource,
  ];

  BrandsState copyWith({
    Optional<XFile>? imageFile,
    Optional<BrandEntity>? selectedBrand,
    Resource<bool>? addBrandResource,
    Resource<bool>? updateBrandResource,
    Resource<bool>? deleteBrandResource,
    Resource<List<BrandEntity>>? brandsResource,
    Resource<bool>? addProductResource,
    Resource<bool>? updateProductResource,
    Resource<bool>? deleteProductResource,
    Resource<List<ProductEntity>>? fetchBrandProductsResource,
  }) {
    return BrandsState(
      imageFile: imageFile != null ? imageFile.value : this.imageFile,
      selectedBrand: selectedBrand != null ? selectedBrand.value : this.selectedBrand,
      brandsResource: brandsResource ?? this.brandsResource,
      addBrandResource: addBrandResource ?? this.addBrandResource,
      updateBrandResource: updateBrandResource ?? this.updateBrandResource,
      deleteBrandResource: deleteBrandResource ?? this.deleteBrandResource,
      addProductResource: addProductResource ?? this.addProductResource,
      updateProductResource: updateProductResource ?? this.updateProductResource,
      deleteProductResource: deleteProductResource ?? this.deleteProductResource,
      fetchBrandProductsResource: fetchBrandProductsResource ?? this.fetchBrandProductsResource,
    );
  }
}