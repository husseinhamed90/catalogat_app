import 'package:catalogat_app/core/helpers/resource.dart';
import 'package:catalogat_app/domain/entities/entities.dart';
import 'package:catalogat_app/domain/repositories/repositories.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddProductUseCase {
  final ProductsRepo _productsRepository;

  AddProductUseCase(this._productsRepository);

  Future<Resource<bool>> call(ProductEntity productEntity) async {
    return await _productsRepository.addProduct((productEntity.copyWith(
      id: FirebaseFirestore.instance.collection('products').doc().id
    )).toModel);
  }
}