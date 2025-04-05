import 'package:get_it/get_it.dart';
import 'package:catalogat_app/domain/use_cases/use_cases.dart';
import 'package:catalogat_app/presentation/blocs/blocs.dart';
import 'package:catalogat_app/data/repositories/repositories.dart';
import 'package:catalogat_app/domain/repositories/repositories.dart';

final sl = GetIt.instance;

void setupLocator() {

  /// Cubits
  sl.registerFactory<BrandsCubit>(() => BrandsCubit(
    sl<AddBrandUseCase>(),
    sl<DeleteBrandUseCase>(),
    sl<UpdateBrandUseCase>(),
    sl<FetchBrandsUseCase>(),
    sl<AddProductUseCase>(),
    sl<UpdateProductUseCase>(),
    sl<DeleteProductUseCase>(),
    sl<FetchBrandProductsUseCase>(),
    sl<UploadFileToFirebaseStorageUseCase>(),
  ));

  /// Repositories
  sl.registerLazySingleton<BrandsRepo>(() => BrandsRepoImpl());
  sl.registerLazySingleton<StorageRepo>(() => StorageRepoImpl());
  sl.registerLazySingleton<ProductsRepo>(() => ProductsRepoImpl());

  /// Use Cases
  sl.registerFactory<AddBrandUseCase>(() => AddBrandUseCase(sl<BrandsRepo>()));
  sl.registerFactory<UpdateBrandUseCase>(() => UpdateBrandUseCase(sl<BrandsRepo>()));
  sl.registerFactory<DeleteBrandUseCase>(() => DeleteBrandUseCase(sl<BrandsRepo>()));
  sl.registerFactory<FetchBrandsUseCase>(() => FetchBrandsUseCase(sl<BrandsRepo>()));

  sl.registerFactory<AddProductUseCase>(() => AddProductUseCase(sl<ProductsRepo>()));
  sl.registerFactory<UpdateProductUseCase>(() => UpdateProductUseCase(sl<ProductsRepo>()));
  sl.registerFactory<DeleteProductUseCase>(() => DeleteProductUseCase(sl<ProductsRepo>()));
  sl.registerFactory<FetchBrandProductsUseCase>(() => FetchBrandProductsUseCase(sl<ProductsRepo>()));

  sl.registerFactory<UploadFileToFirebaseStorageUseCase>(() => UploadFileToFirebaseStorageUseCase(sl<StorageRepo>()));
}