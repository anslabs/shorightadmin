
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';

class ProductService{
  Firestore _firestore = Firestore.instance;
  String ref = "products";




  void uploadProduct({String productName, String brandId, String brand, String categoryId,  String category, String subCategoryId,  String subCategory, int quantity, List sizes, List images, double price, double oldprice, String description, List colors, int tva, double remise}){
    var id = Uuid();
    String productId = id.v1();

    _firestore.collection(ref).add({
      'id':productId,
      'name':productName,
      "brandId" : brandId,
      'brand': brand,
      'categoryId': categoryId,
      'category': category,
      'subcategoryId': subCategoryId,
      'subcategory': subCategory,
      'quantity': quantity,
      'sizes': sizes,
      'images': images,
      'price': price,
      'oldprice': oldprice,
      'color' : colors,
      'description': description,
      'flash':'faux',
      'tva':tva,
      'remise': remise,
    });
  }


}