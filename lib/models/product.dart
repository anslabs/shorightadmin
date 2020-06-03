import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Product {
  static const String BRAND = "brand";
  static const String BRANDID = "brandId";
  static const String CATEGORY = "category";
  static const String CATEGORYID = "categoryId";
  static const String SUBCATEGORY = "subcategory";
  static const String SUBCATEGORYID = "subcategoryId";
  static const String COLORS = "color";
  static const String ID = "id";
  static const String NAME = "name";
  static const String IMAGES = "images";
  static const String DESCRIPTION = "description";
  static const String PRICE = "price";
  static const String OLDPRICE = "oldPrice";
  static const String QUANTITY = "quantity";
  static const String SIZES = "sizes";

  String _brand;
  String _brandId;
  String _subcategoryId;
  String _subcategory;
  String _category;
  String _categoryId;
  List<String> _colors;
  int _id;
  String _name;
  List<String> _images;
  String _description;
  double _price;
  double _oldPrice;
  int _quantity;
  List<String> _sizes;

  String get brand => _brand;

  String get brandId => _brandId;

  String get subcategoryId => _subcategoryId;

  String get category => _category;

  String get categoryId => _categoryId;

  List<String> get colors => _colors;

  int get id => _id;

  String get name => _name;

  List<String> get images => _images;

  String get description => _description;

  double get price => _price;

  double get oldPrice => _oldPrice;

  int get quantity => _quantity;

  List<String> get sizes => _sizes;

  String get subcategory => _subcategory;

  Product.fromSnapshot(DocumentSnapshot snapshot){
    Map data = snapshot.data;
    _brand = data[BRAND];
    _category = data[CATEGORY];
    _subcategory = data[SUBCATEGORY];
    _colors = data[COLORS];
    _id = data[ID];
    _name = data[NAME];
    _images = data[IMAGES];
    _description = data[DESCRIPTION];
    _quantity = data[QUANTITY];
    _sizes = data[SIZES];
    _price = data[PRICE];
    _oldPrice = data[OLDPRICE];
  }
}
