import 'package:catalogat_app/data/models/models.dart';
import 'package:catalogat_app/core/helpers/resource.dart';
import 'package:catalogat_app/domain/entities/entities.dart';

abstract class CustomerRepository {
  Future<Resource<List<CustomerEntity>>> getCustomers();
  Future<Resource<CustomerEntity>> addCustomer(AddCustomerParams customerRequest);
}