import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/domain/entities/entities.dart';
import 'package:catalogat_app/domain/repositories/repositories.dart';

class FetchCustomerUseCase {

  final CustomerRepository _customersRepo;
  FetchCustomerUseCase(this._customersRepo);

  Future<Resource<List<CustomerEntity>>> call() async {
    return await _customersRepo.getCustomers();
  }
}