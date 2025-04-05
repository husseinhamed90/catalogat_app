import 'package:catalogat_app/core/helpers/resource.dart';
import 'package:catalogat_app/data/models/product_model.dart';
import 'package:catalogat_app/domain/entities/product_entity.dart';
import 'package:catalogat_app/domain/repositories/products/products_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductsRepoImpl implements ProductsRepo {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  @override
  Future<Resource<bool>> addProduct(ProductModel product) async{
    try {
      await fireStore
          .collection('brands')
          .doc(product.brandId)
          .update({
            'products': FieldValue.arrayUnion([product.toJson()]),
          });
      return Resource.success(true);
    } catch (e) {
      return Resource.failure("Failed to add product");
    }
  }

  @override
  Future<Resource<bool>> deleteProduct(String productId,String brandId) async {
    try {
      final brandDocRef = fireStore.collection('brands').doc(brandId);
      await brandDocRef.get().then((brandSnapshot) {
        if (brandSnapshot.exists) {
          List<dynamic> products = List.from(brandSnapshot['products']);
          products.removeWhere((product) => product['id'] == productId);
          brandDocRef.update({'products': products});
        }
      });
      return Resource.success(true);
    } catch (e) {
      return Resource.failure("Failed to delete product");
    }
  }

  @override
  Future<Resource<List<ProductEntity>>> getProductsByBrand(String brandId) async {
    try {
      final snapshot = await fireStore
          .collection('brands')
          .doc(brandId)
          .collection('products')
          .get();
      final products = snapshot.docs.map((doc) => ProductModel.fromJson(doc.data())).toList();
      return Resource.success(products.map((product) => product.toEntity()).toList());
    } catch (e) {
      return Resource.failure("Failed to fetch products");
    }
  }

  @override
  Future<Resource<bool>> updateProduct(ProductModel product) async {
    try {
      final brandDocRef = fireStore.collection('brands').doc(product.brandId);
      await brandDocRef.get().then((brandSnapshot) {
        if (brandSnapshot.exists) {
          List<dynamic> products = List.from(brandSnapshot['products']);
          int index = products.indexWhere((p) => p['id'] == product.id);
          if (index != -1) {
            products[index] = product.toJson();
            brandDocRef.update({'products': products});
          }
        }
      });
      return Resource.success(true);
    } catch (e) {
      return Resource.failure("Failed to update product");
    }
  }
}