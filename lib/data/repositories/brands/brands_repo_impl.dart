import 'package:catalogat_app/data/models/brand_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:catalogat_app/core/helpers/resource.dart';
import 'package:catalogat_app/domain/entities/brand_entity.dart';
import 'package:catalogat_app/domain/repositories/repositories.dart';

class BrandsRepoImpl extends BrandsRepo {

  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  @override
  Future<Resource<bool>> addBrand(BrandModel brand) async {
    try {
     final documentReference = await fireStore.collection('brands').add(brand.toJson());
     await documentReference.set({
       'id': documentReference.id,
     }, SetOptions(merge: true));
      return Resource.success(true);
    } catch (e) {
      return Resource.failure("Failed to add brand");
    }
  }

  @override
  Future<Resource<bool>> deleteBrand(String brandId) async{
    try {
      await fireStore.collection('brands').doc(brandId).delete();
      return Resource.success(true);
    } catch (e) {
      return Resource.failure("Failed to delete brand");
    }
  }

  @override
  Future<Resource<List<BrandEntity>>> getBrands() async{
    try {
      final snapshot = await fireStore.collection('brands').get();
      final brands = snapshot.docs.map((doc) => BrandModel.fromJson(doc.data())).toList();
      return Resource.success(brands.map((brand) => brand.toEntity()).toList());
    } catch (e) {
      return Resource.failure("Failed to fetch brands");
    }
  }

  @override
  Future<Resource<bool>> updateBrand(BrandModel brand) async{
    try {
      await fireStore.collection('brands').doc(brand.id).update(brand.toJson());
      return Resource.success(true);
    } catch (e) {
      return Resource.failure("Failed to update brand");
    }
  }
}