import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/data/models/models.dart';
import 'package:catalogat_app/domain/entities/entities.dart';
import 'package:catalogat_app/domain/repositories/repositories.dart';

class SaveNewCustomerUseCase {
  final CustomerRepository _repository;

  SaveNewCustomerUseCase(this._repository);

  Future<Resource<CustomerEntity>> call(String customerName) async {
    return await _repository.addCustomer(
      AddCustomerParams(
        customerName: customerName,
      ),
    );
  }
}