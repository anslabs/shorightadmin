
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class SubCategoryService{
  Firestore _firestore = Firestore.instance;
  String ref = "subcategories";

  void createSubCategory(String idCategory, String categoryName, String name, String image){
    _firestore.collection(ref).add({
      'categoryId': idCategory,
      'categoryName': categoryName,
      'subcategory': name,
      'sbimage':image,
    });
  }

  Future<List<DocumentSnapshot>>  getSubCategories(String categoryId) =>
      _firestore.collection(ref).getDocuments().then((snaps) {
        return snaps.documents;
      });

  // getCategoriesById(String id) =>
  Future<DocumentSnapshot>  getSousCategoriesById(String id) =>
      _firestore.collection(ref).document(id).get().then((doc) {
        return doc;
      });


  Future<List<DocumentSnapshot>> getSuggestion(String suggestion, String categoryId) {
  print(categoryId);
    return  _firestore.collection(ref).where('subcategory', isEqualTo:suggestion).where('categoryId', isEqualTo: categoryId).getDocuments().then((snap){
        return snap.documents;
      });
}
}