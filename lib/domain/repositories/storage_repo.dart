import 'package:catalogat_app/core/dependencies.dart';

abstract class StorageRepo {
  Future<Resource<String>> uploadFile(String fileLocalPath);
}