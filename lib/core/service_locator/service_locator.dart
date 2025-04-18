import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:catalogat_app/core/constants/app_constants.dart';
import 'package:catalogat_app/data/sources/supabase_service.dart';
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
    sl<UploadFileToStorageUseCase>(),
    sl<ReorderBrandProductsUseCase>(),
  ));

  sl.registerFactory<CompanyCubit>(() => CompanyCubit(
    sl<UploadFileToStorageUseCase>(),
    sl<FetchCompanyInfoUseCase>(),
    sl<UpdateCompanyInfoUseCase>(),
  ));

  sl.registerFactory<CustomersCubit>(() => CustomersCubit(
      sl<FetchCustomerUseCase>(),
      sl<SaveNewCustomerUseCase>(),
      sl<DeleteSelectedCustomersUseCase>(),
  ));

  sl.registerFactory<ShoppingCubit>(() => ShoppingCubit());

  sl.registerFactory<OrderCubit>(() => OrderCubit(
    sl<CreateOrderUseCase>(),
    sl<FetchOrdersUseCase>(),
    sl<GenerateOrderReportUseCase>(),
    sl<DeleteSelectedOrdersUseCase>(),
  ));

  /// Repositories
  sl.registerLazySingleton<BrandsRepo>(() => BrandsRepoImpl(sl<SupabaseService>()));
  sl.registerLazySingleton<StorageRepo>(() => StorageRepoImpl());
  sl.registerLazySingleton<ProductsRepo>(() => ProductsRepoImpl(sl<SupabaseService>()));
  sl.registerLazySingleton<CustomerRepository>(() => CustomersRepoImpl(sl<SupabaseService>()));
  sl.registerLazySingleton<OrdersRepository>(() => OrdersRepositoryImpl(sl<SupabaseService>()));
  sl.registerLazySingleton<CompanyRepository>(() => CompanyRepositoryImpl(sl<SupabaseService>()));

  /// Use Cases
  sl.registerFactory<AddBrandUseCase>(() => AddBrandUseCase(sl<BrandsRepo>()));
  sl.registerFactory<UpdateBrandUseCase>(() => UpdateBrandUseCase(sl<BrandsRepo>()));
  sl.registerFactory<DeleteBrandUseCase>(() => DeleteBrandUseCase(sl<BrandsRepo>()));
  sl.registerFactory<FetchBrandsUseCase>(() => FetchBrandsUseCase(sl<BrandsRepo>()));

  sl.registerFactory<AddProductUseCase>(() => AddProductUseCase(sl<ProductsRepo>()));
  sl.registerFactory<UpdateProductUseCase>(() => UpdateProductUseCase(sl<ProductsRepo>()));
  sl.registerFactory<DeleteProductUseCase>(() => DeleteProductUseCase(sl<ProductsRepo>()));

  sl.registerFactory<UploadFileToStorageUseCase>(() => UploadFileToStorageUseCase(sl<StorageRepo>()));

  sl.registerFactory<FetchOrdersUseCase>(() => FetchOrdersUseCase(sl<OrdersRepository>()));
  sl.registerFactory<CreateOrderUseCase>(() => CreateOrderUseCase(sl<OrdersRepository>()));
  sl.registerFactory<GenerateOrderReportUseCase>(() => GenerateOrderReportUseCase());
  sl.registerFactory<FetchCustomerUseCase>(() => FetchCustomerUseCase(sl<CustomerRepository>()));
  sl.registerFactory<SaveNewCustomerUseCase>(() => SaveNewCustomerUseCase(sl<CustomerRepository>()));
  sl.registerFactory<UpdateCompanyInfoUseCase>(() => UpdateCompanyInfoUseCase(sl<CompanyRepository>()));
  sl.registerFactory<FetchCompanyInfoUseCase>(() => FetchCompanyInfoUseCase(sl<CompanyRepository>()));
  sl.registerFactory<DeleteSelectedOrdersUseCase>(() => DeleteSelectedOrdersUseCase(sl<OrdersRepository>()));
  sl.registerFactory<DeleteSelectedCustomersUseCase>(() => DeleteSelectedCustomersUseCase(sl<CustomerRepository>()));
  sl.registerFactory<ReorderBrandProductsUseCase>(() => ReorderBrandProductsUseCase(sl<BrandsRepo>()));

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