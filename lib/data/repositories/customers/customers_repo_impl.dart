import 'package:catalogat_app/data/models/models.dart';
import 'package:catalogat_app/core/helpers/resource.dart';
import 'package:catalogat_app/domain/entities/entities.dart';
import 'package:catalogat_app/data/sources/supabase_service.dart';
import 'package:catalogat_app/domain/repositories/repositories.dart';

class CustomersRepoImpl implements CustomerRepository {

  final SupabaseService _supabaseService;

  CustomersRepoImpl(this._supabaseService);

  @override
  Future<Resource<CustomerEntity>> addCustomer(AddCustomerParams customerRequest) async {
    try {
      final response = await _supabaseService.addCustomer(customerRequest);
      return response.toResource((data) => data.toEntity());
    } catch (e) {
      return Resource.failure("Failed to add customer");
    }
  }

  @override
  Future<Resource<List<CustomerEntity>>> getCustomers() async {
    try {
      final response = await _supabaseService.getCustomers();
      return response.toResource((data) => data.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Resource.failure("Failed to fetch customers");
    }
  }

}