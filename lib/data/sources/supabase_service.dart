import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:catalogat_app/data/models/models.dart';

part 'supabase_service.g.dart';

@RestApi()
abstract class SupabaseService {
  factory SupabaseService(Dio dio, {String baseUrl}) = _SupabaseService;

  @GET('get_brands_with_products')
  Future<ApiResult<List<BrandModel>>> getBrandsWithProducts();

  //add_brand
  @POST('add_brand')
  Future<ApiResult<BrandModel>> addBrand(@Body() AddBrandParams brandRequest);

  //delete_brand
  @POST('delete_brand')
  Future<ApiResult<BrandModel>> deleteBrand(@Body() DeleteBrandParams brandRequest);


  //update_brand
  @POST('update_brand')
  Future<ApiResult<BrandModel>> updateBrand(@Body() UpdateBrandParams brandRequest);


  //add_product
  @POST('add_product')
  Future<ApiResult<ProductModel>> addProduct(@Body() AddProductParams productRequest);

  //update_product
  @POST('update_product')
  Future<ApiResult<ProductModel>> updateProduct(@Body() UpdateProductParams updateProductParams);

  //delete_product
  @POST('delete_product')
  Future<ApiResult<ProductModel>> deleteProduct(@Body() DeleteProductParams deleteProductParams);

  //createOrder
  @POST('create_full_order')
  Future<ApiResult<OrderModel>> createOrder(@Body() CreateOrderParams orderRequest);

  //getOrders
  @GET('get_orders')
  Future<ApiResult<List<OrderModel>>> getOrders();
}