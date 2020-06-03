
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shorightadmin/db/brand.dart';
import 'package:shorightadmin/db/category.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shorightadmin/db/product.dart';
import 'package:shorightadmin/db/subcategory.dart';
import 'package:image_picker/image_picker.dart';


class AddSubCategory extends StatefulWidget {
  @override
  _AddSubCategoryState createState() => _AddSubCategoryState();
}

class _AddSubCategoryState extends State<AddSubCategory> {

  Color white = Colors.white;
  Color black = Colors.black;
  Color green = Colors.green;
  Color grey = Colors.grey;
  Color red = Colors.red;

  List<DocumentSnapshot> categories = <DocumentSnapshot>[];

  TextEditingController subcategoryController = TextEditingController();


  List<DropdownMenuItem<String>> categoriesDropDown = <DropdownMenuItem<String>>[];
  String _currentCategory ;
  String _currentCategoryName ;

  CategoryService _categoryService = CategoryService();

  bool isLoading = false;

  SubCategoryService _subcategoryService = SubCategoryService();
  File _image1;



  @override
  void initState() {
     // _getCategories();
      //getCategoriesDropDown();
     // _currentCategory = categoriesDropDown[0].value;
    super.initState();
  }
  GlobalKey<FormState>  _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        iconTheme: IconThemeData(color: Colors.black54),
      //  leading: Icon(Icons.close, color: black,),
        title: Text("Add product", style: TextStyle(color: black),),
      ),
      body: Form(
        key: _formKey,
        child: isLoading? Center(child: CircularProgressIndicator()): ListView(
          children: <Widget>[

            Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlineButton(
                  borderSide: BorderSide(color: grey.withOpacity(0.5), width: 1.0),
                  onPressed: (){_selectImage(ImagePicker.pickImage(source: ImageSource.gallery));},
                  child:_image1 == null?
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 50, 14, 50),
                    child: Icon(Icons.add, color: grey,),
                  )
                      :Image.file(_image1, fit: BoxFit.fill, width: double.infinity, height: 350.0,),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Entrez le nom du produit", style: TextStyle(color: Colors.red), textAlign: TextAlign.center,),
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                controller: subcategoryController,
                decoration: InputDecoration(
                    hintText: 'Sous catégorie'
                ),
                validator: (value){
                  if(value.isEmpty){
                    return"You must enter the subcategory name";
                  }
                  else if(value.length<3){
                    return'product namecant be less than 3';
                  }
                  return null;
                },
              ),
            ),


            SizedBox(height: 40.0),



      StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('categories').snapshots(), builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );

        return Container(
          padding: EdgeInsets.only(bottom: 16.0),
          child: Row(
            children: <Widget>[
              Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(12.0, 10.0, 10.0, 10.0),
                    child: Text(
                      "Catégorie",
                    ),
                  )),
              new Expanded(
                flex: 4,
                child: DropdownButton(
                  value: _currentCategory,
                  isDense: true,
                  onChanged: (valueSelectedByUser) async{
                  await  _onShopDropItemSelected(valueSelectedByUser);
                  },
                  hint: Text('Choisissez la catégorie'),
                  items: snapshot.data.documents.map((DocumentSnapshot document) {
                    return DropdownMenuItem<String>(
                      value: document.documentID,
                      child: Text(document.data['category']
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      }),

            FlatButton(
              color: red,
              textColor: white,
              child: Text("Ajouter"),
              onPressed: (){

                setState(() {
                  isLoading = true;
                });

                if (_image1 != null) {
                  String imageUrl1;
                  StorageReference storageReference = FirebaseStorage.instance.ref();
                  StorageReference ref = storageReference.child("subcategories/");
                  final String picture1 = "${DateTime.now().millisecondsSinceEpoch.toString()}";
                  StorageUploadTask task1 =  ref.child(picture1).putFile(_image1);

                  task1.onComplete.then((snapshot1) async {
                    imageUrl1 = await snapshot1.ref.getDownloadURL();

                    String imagesb = imageUrl1;


                      if (subcategoryController.text != null &&
                          _currentCategory != null &&
                          _currentCategoryName != null) {
                        _subcategoryService.createSubCategory(
                            _currentCategory, _currentCategoryName,
                            subcategoryController.text, imagesb);
                        Fluttertoast.showToast(msg: 'souscatégorie créée');
                        setState(() {
                          isLoading = false;
                        });
                      }
                      else {
                        setState(() {
                          isLoading = false;
                        });

                        Fluttertoast.showToast(
                            msg: 'Make sure to select catogy and enter sous categori nazem');
                      }
                  });
                }
                else{
                  setState(() {
                    isLoading = false;
                  });

                  Fluttertoast.showToast(msg: 'Make sure to pickan image');
                }

              },
            ),

          ],
        ),
      ),
    );
  }

 Future <void> _onShopDropItemSelected(String newValueSelected) async{
    setState(() {
      this._currentCategory = newValueSelected;
    });
    print(_currentCategory);
// _currentCategoryName = _categoryService.getCategoriesById(_currentCategory).data["category"];

await  _getCategoriesName(_currentCategory);
  }

 Future <void> _getCategoriesName(String id) async{
 DocumentSnapshot data = await _categoryService.getCategoriesById(id);
    print('data is : $data');
    setState(() {
      _currentCategoryName = data.data["category"];
      print('from _getCategoriesName, _currentCategoryName,  :$_currentCategoryName');
    });
  }


  List<DropdownMenuItem<String>>  getCategoriesDropDown() {
    List<DropdownMenuItem<String>> items = List();
    for(int i = 0; i < categories.length; i++){
      setState(() {
        items.insert(0, DropdownMenuItem(child: Text(categories[i].data['category'],), value: categories[i].documentID));
      });
    }
    print('getCategoriesDropDown are: ${items.length}');
    return items;
  }


  void _getCategories() async{
    List<DocumentSnapshot> data = await _categoryService.getCategories();
    print('_getCategories are: ${data.length}');
    print('data is : $data');
    setState(() {
      categories = data;
      _currentCategory = categories[0].data['category'];
      print('from AddSubCategory, _getCategories, _currentCategory :');
      print( categories[0].data['category']);
      categoriesDropDown = getCategoriesDropDown();
      print(categories.length);
    });

  }


  changeSelectedCategory(String selectedCategory) {
    setState(() {
      _currentCategory = selectedCategory;
    });
  }

  void _selectImage(Future<File> pickImage) async{
    File tmpImg = await pickImage;
        setState(() {
          _image1 =  tmpImg;
          print(_image1.path.split(".").last);
        });
  }


}

