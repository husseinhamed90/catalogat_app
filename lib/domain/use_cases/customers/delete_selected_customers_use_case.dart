import 'package:catalogat_app/core/helpers/resource.dart';
import 'package:catalogat_app/domain/repositories/repositories.dart';

class DeleteSelectedCustomersUseCase {
  final CustomerRepository _customerRepository;

  DeleteSelectedCustomersUseCase(this._customerRepository);

  Future<Resource<int>> call(List<String> customerIds) async {
    return await _customerRepository.deleteSelectedCustomers(customerIds);
  }
}