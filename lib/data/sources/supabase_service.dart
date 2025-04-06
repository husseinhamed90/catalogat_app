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
}