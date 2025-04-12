import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/domain/entities/entities.dart';

class FetchCustomerUseCase {

  FetchCustomerUseCase();

  Future<Resource<List<CustomerEntity>>> call() async {
    await Future.delayed(const Duration(seconds: 4));
    return Resource.success([
      CustomerEntity(
        id: '1',
        name: 'John Doe',
      ),
      CustomerEntity(
        id: '2',
        name: 'Jane Smith',
      ),
      CustomerEntity(
        id: '3',
        name: 'Alice Johnson',
      ),
      CustomerEntity(
        id: '4',
        name: 'Bob Brown',
      ),
    ]);
  }
}