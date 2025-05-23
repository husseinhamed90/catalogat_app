import 'package:catalogat_app/core/constants/app_constants.dart';
import 'package:catalogat_app/data/sources/supabase_service.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
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
    sl<UploadFileToStorageUseCase>()
  ));

  /// Repositories
  sl.registerLazySingleton<BrandsRepo>(() => BrandsRepoImpl(sl<SupabaseService>()));
  sl.registerLazySingleton<StorageRepo>(() => StorageRepoImpl());
  sl.registerLazySingleton<ProductsRepo>(() => ProductsRepoImpl(sl<SupabaseService>()));

  /// Use Cases
  sl.registerFactory<AddBrandUseCase>(() => AddBrandUseCase(sl<BrandsRepo>()));
  sl.registerFactory<UpdateBrandUseCase>(() => UpdateBrandUseCase(sl<BrandsRepo>()));
  sl.registerFactory<DeleteBrandUseCase>(() => DeleteBrandUseCase(sl<BrandsRepo>()));
  sl.registerFactory<FetchBrandsUseCase>(() => FetchBrandsUseCase(sl<BrandsRepo>()));

  sl.registerFactory<AddProductUseCase>(() => AddProductUseCase(sl<ProductsRepo>()));
  sl.registerFactory<UpdateProductUseCase>(() => UpdateProductUseCase(sl<ProductsRepo>()));
  sl.registerFactory<DeleteProductUseCase>(() => DeleteProductUseCase(sl<ProductsRepo>()));

  sl.registerFactory<UploadFileToStorageUseCase>(() => UploadFileToStorageUseCase(sl<StorageRepo>()));

  sl.registerLazySingleton<Dio>(() => Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        ApiConstants.apikey: AppConstants.supabaseAnonKey,
      },
    ),
  ));

  /// Api services
  sl.registerLazySingleton<SupabaseService>(() => SupabaseService(sl(),baseUrl: AppConstants.supabaseUrl));
}