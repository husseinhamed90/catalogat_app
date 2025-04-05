import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/domain/repositories/storage_repo.dart';

class StorageRepoImpl implements StorageRepo {

  @override
  Future<Resource<String>> uploadFile(String fileLocalPath) async {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dd7vqecuj/upload');
    final request = http.MultipartRequest('POST', url)
    ..fields['upload_preset'] = '23sds432'
    ..files.add(await http.MultipartFile.fromPath('file', fileLocalPath));

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final jsonMap = jsonDecode(responseString);
      return Resource.success(jsonMap['url']);
    }
    else {
      return Resource.failure('Failed to upload image');
    }
  }
}