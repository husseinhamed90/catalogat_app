import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/domain/repositories/repositories.dart';

class UploadFileToStorageUseCase {
  final StorageRepo _storageRepository;

  UploadFileToStorageUseCase(this._storageRepository);

  Future<Resource<String>?> call(String fileLocalPath) async {
    return await _storageRepository.uploadFile(fileLocalPath);
  }
}