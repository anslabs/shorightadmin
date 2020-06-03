
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class CategoryService{
  Firestore _firestore = Firestore.instance;
  String ref = "categories";

  void createCategory(String name, String image){
    _firestore.collection(ref).add({
      'category': name,
      'cimage': image,
    });
  }

  Future<List<DocumentSnapshot>>  getCategories() =>
      _firestore.collection(ref).getDocuments().then((snaps) {
        return snaps.documents;
      });

   // getCategoriesById(String id) =>
      Future<DocumentSnapshot>  getCategoriesById(String id) =>
      _firestore.collection(ref).document(id).get().then((doc) {
        return doc;
//      if (doc != null) {
//        print("document found") ;
//        print("${doc.data['category']}") ;
//      } else {
//          print("document not found");
//      }
      });

  Future<List<DocumentSnapshot>> getSuggestion(String suggestion) =>
   _firestore.collection(ref).where('category', isEqualTo:suggestion).getDocuments().then((snap){
        return snap.documents;
      });

}