import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/domain/repositories/repositories.dart';

class UploadFileToFirebaseStorageUseCase {
  final StorageRepo _firebaseStorageRepository;

  UploadFileToFirebaseStorageUseCase(this._firebaseStorageRepository);

  Future<Resource<String>?> call(String fileLocalPath) async {
    return await _firebaseStorageRepository.uploadFile(fileLocalPath);
  }
}