part of 'brands_cubit.dart';

class BrandsState extends Equatable {

  final XFile? imageFile;
  final BrandEntity? selectedBrand;
  final String productName;
  final String productPrice1;
  final String productPrice2;
  final Resource<BrandEntity> updateBrandResource;
  final Resource<BrandEntity> deleteBrandResource;
  final Resource<ProductEntity> addProductResource;
  final Resource<ProductEntity> updateProductResource;
  final Resource<bool> deleteProductResource;
  final Resource<List<BrandEntity>> brandsResource;
  final Resource<BrandEntity> addBrandResource;
  final Resource<List<ProductEntity>> fetchBrandProductsResource;

  const BrandsState({
    this.imageFile,
    this.selectedBrand,
    this.productName = '',
    this.productPrice1 = '',
    this.productPrice2 = '',
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
    productName,
    productPrice1,
    productPrice2,
    addBrandResource,
    updateBrandResource,
    deleteBrandResource,
    addProductResource,
    updateProductResource,
    deleteProductResource,
    fetchBrandProductsResource,
  ];

  BrandsState copyWith({
    String? productName,
    String? productPrice1,
    String? productPrice2,
    Optional<XFile>? imageFile,
    Optional<BrandEntity>? selectedBrand,
    Resource<BrandEntity>? addBrandResource,
    Resource<BrandEntity>? updateBrandResource,
    Resource<BrandEntity>? deleteBrandResource,
    Resource<List<BrandEntity>>? brandsResource,
    Resource<ProductEntity>? addProductResource,
    Resource<ProductEntity>? updateProductResource,
    Resource<bool>? deleteProductResource,
    Resource<List<ProductEntity>>? fetchBrandProductsResource,
  }) {
    return BrandsState(
      productName: productName ?? this.productName,
      productPrice1: productPrice1 ?? this.productPrice1,
      productPrice2: productPrice2 ?? this.productPrice2,
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