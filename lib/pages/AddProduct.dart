import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:shorightadmin/db/brand.dart';
import 'package:shorightadmin/db/category.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shorightadmin/db/product.dart';
import 'package:shorightadmin/db/subcategory.dart';
import 'package:shorightadmin/db/test.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {

  Color white = Colors.white;
  Color black = Colors.black;
  Color green = Colors.green;
  Color grey = Colors.grey;
  Color red = Colors.red;

  TextEditingController remiseController = TextEditingController();
  TextEditingController tvaController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController oldPriceController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  TextEditingController subcategoryController = TextEditingController();
  TextEditingController typeAheadController = TextEditingController();


  List<DocumentSnapshot> brands = <DocumentSnapshot>[];
  List<DocumentSnapshot> categories = <DocumentSnapshot>[];
  List<DocumentSnapshot> subcategories = <DocumentSnapshot>[];


  List<DropdownMenuItem<String>> categoriesDropDown = <DropdownMenuItem<String>>[];
  List<DropdownMenuItem<String>> subcategoriesDropDown = <DropdownMenuItem<String>>[];
  List<DropdownMenuItem<String>> brandDropDown = <DropdownMenuItem<String>>[];

  String _currentCategory;
  String _currentCategoryName;
  String _currentBrandName;
  String _currentSubCategoryName;
  var _currentSubCategory;
  String _currentCategoryId;
  String _currentBrand  ;

  SubCategoryService _subcategoryService = SubCategoryService();
  CategoryService _categoryService = CategoryService();
  BrandService _brandService = BrandService();
  ProductService _productService = ProductService();
  TestService _testService = TestService();



  List<String> selectedSizes = <String>[];
  List<String> _checkedColors = <String>[];
  bool isLoading = false;

  File _image1;
  File _image2;
  File _image3;

  String defaultDescription = "Par ailleurs, si l\'on consulte le site de la fondation Apache, on se retrouve avec quatre versions majeures Hadoop. À l\'écriture de cet article et de mes premières expérimentations, il s\'agissait des versions 0.23.X, 1.2.X, 2.2.X et 2.X.X. Les trois premières versions correspondent à des versions stables et aptes à passer en production. La dernière est la version en cours. Puisque je n'ai pas d'antériorité avec Hadoop, j'ai pris le risque de la nouveauté en utilisant la version majeure 2.3.X fournie avec la distribution de Cloudera. Dans le cas de Cloudera, l\'alignement des versions avec celle d'Hadoop n'est pas identique. La version actuelle de Cloudera est la 5 ce qui correspond en gros à la version 2.3.X de la fondation Apache. Dans la suite de ce tutoriel, nous utiliserons Cloudera 5 Standard. À la différence de la version proposée par Apache où il est nécessaire de télécharger une archive, la version Hadoop de Cloudera fournit une installation via des packages. Intéressons-nous donc, dans la suite, à voir comment installer Hadoop avec la distribution Cloudera.";

  @override
  void initState() {
   // getCategoriesDropDown();
  //  print(categoriesDropDown.length);
   // _getCategories();
  //  _getBrands();
    //_getBrands();
 //  _currentCategory = categoriesDropDown[0].value;
    super.initState();
  }
  GlobalKey<FormState>  _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
  //  print(_currentCategory);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black54),
       // leading: Icon(Icons.close, color: black,),
        title: Text("Add product", style: TextStyle(color: black),),
      ),
      body: Form(
        key: _formKey,
        child: isLoading? Center(child: CircularProgressIndicator()): ListView(
          children: <Widget>[
            Row(
              children: <Widget>[

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlineButton(
                  borderSide: BorderSide(color: grey.withOpacity(0.5), width: 1.0),
                  onPressed: (){_selectImage(ImagePicker.pickImage(source: ImageSource.gallery), 1);},
                  child:_image1 == null?
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 50, 14, 50),
                    child: Icon(Icons.add, color: grey,),
                  )

                      :Image.file(_image1, fit: BoxFit.fill, width: double.infinity,),


                ),
              ),
            ),


            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlineButton(
                  borderSide: BorderSide(color: grey.withOpacity(0.5), width: 1.0),
                  onPressed: (){_selectImage(ImagePicker.pickImage(source: ImageSource.gallery, ), 2);},
                    child:_image2 == null?
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 50, 14, 50),
                      child: Icon(Icons.add, color: grey,),
                    )

                        :Image.file(_image2, fit: BoxFit.fill, width: double.infinity,),

                ),
              ),
            ),


            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlineButton(
                  borderSide: BorderSide(color: grey.withOpacity(0.5), width: 1.0),
                  onPressed: (){_selectImage(ImagePicker.pickImage(source: ImageSource.gallery, ), 3);},
                    child:_image3 == null?
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 50, 14, 50),
                      child: Icon(Icons.add, color: grey,),
                    )

                        :Image.file(_image3, fit: BoxFit.fill, width: double.infinity,),


                ),
              ),
            ),

              ],
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Entrez le nom du produit", style: TextStyle(color: Colors.red), textAlign: TextAlign.center,),
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                    hintText: 'Product name'
                ),
                validator: (value){
                  if(value.isEmpty){
                    return"You must enter the product name";
                  }
                  else if(value.length<3){
                    return'product namecant be less than 10 ';
                  }
                  return null;
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Entrez la TVA", style: TextStyle(color: Colors.red), textAlign: TextAlign.center,),
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                controller: tvaController,
                decoration: InputDecoration(
                    hintText: 'TVA '
                ),
                validator: (value){
                  if(value.isEmpty){
                    return"You must enter the TVA";
                  }
                  return null;
                },
              ),
            ),


            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Entrez la remise", style: TextStyle(color: Colors.red), textAlign: TextAlign.center,),
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                controller: remiseController,
                decoration: InputDecoration(
                    hintText: 'Remise '
                ),
                validator: (value){
                  if(value.isEmpty){
                    return"You must enter the remise";
                  }
                  return null;
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Détails", style: TextStyle(color: Colors.red), textAlign: TextAlign.center,),
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                child: TextFormField(
                  controller: detailsController,
                  decoration: InputDecoration(
                      hintText: 'Détails du produit'
                  ),
                  validator: (value){
                    if(value.isEmpty){
                      return"You must enter the details";
                    }
                    else if(value.length<10){
                      return'details cant be less than 10 ';
                    }
                    return null;
                  },
                ),
              ),
            ),


            StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection('brands').snapshots(), builder: (context, snapshot) {
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
                            "Marque",
                          ),
                        )),
                    new Expanded(
                      flex: 4,
                      child: DropdownButton(
                        value: _currentBrand,
                        isDense: true,
                        onChanged: (valueSelectedByUser) async{
                          await  _onBrandDropItemSelected(valueSelectedByUser);
                        },
                        hint: Text('Choisissez la marque'),
                        items: snapshot.data.documents.map((DocumentSnapshot document) {
                          return DropdownMenuItem<String>(
                            value: document.documentID,
                            child: Text(document.data['brand']
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              );
            }),




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


            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Sous-catégorie:'),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TypeAheadField(
                textFieldConfiguration: TextFieldConfiguration(
                    autofocus: false,
                    style: DefaultTextStyle.of(context).style.copyWith(
                        fontStyle: FontStyle.italic,
                      fontSize: 15,
                      height: 0.3,
                    ),
                    controller: typeAheadController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder()
                    )
                ),
                suggestionsCallback: (pattern) async {
                  return await _subcategoryService.getSuggestion(pattern, _currentCategory == null? _currentCategoryId : _currentCategory);
                  //return await _subcategoryService.getSuggestion(pattern);
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    leading: Icon(Icons.shopping_cart),
                 //   title: Text(suggestion['categoryId']),
                    title: Text('${suggestion['subcategory']}'),
                    subtitle: Text(suggestion.documentID),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  _currentSubCategory = suggestion.documentID;
                  print(' _currentSubCategory: $_currentSubCategory');
                  _currentSubCategoryName = suggestion.data["subcategory"];
                  _currentCategoryId = suggestion.data["categoryId"];
                  print(' _currentSubCategoryName: ${_currentSubCategoryName}');

                },


              ),
            ),


            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: quantityController,
                keyboardType: TextInputType.number,
               // initialValue: '1',

                decoration: InputDecoration(
                    hintText: 'Quantity',
                  labelText: 'Quantity'
                ),
                validator: (value){
                  if(value.isEmpty){
                    return 'you must enter a quantity';
                  }
                  return null;
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: 'Price'
                ),
                validator: (value){
                  if(value.isEmpty){
                    return 'you must enter a Price';
                  }
                  return null;
                },
              ),
            ),


            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: oldPriceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: 'Old Price'
                ),
                validator: (value){
                  if(value.isEmpty){
                    return 'you must enter a Price';
                  }
                  return null;
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Sizes'),
            ),

            Row(
              children: <Widget>[
                Checkbox( value: selectedSizes.contains("XS"), onChanged: (value) => selctedSizeContains("XS"), ),
                Text('XS'),

                Checkbox( value: selectedSizes.contains("S"), onChanged: (value) => selctedSizeContains("S"), ),
                Text('S'),

                Checkbox( value: selectedSizes.contains("M"), onChanged: (value) => selctedSizeContains("M"), ),
                Text('M'),

                Checkbox( value: selectedSizes.contains("L"), onChanged: (value) => selctedSizeContains("L"), ),
                Text('L'),

                Checkbox( value: selectedSizes.contains("XL"), onChanged: (value) => selctedSizeContains("XL"), ),
                Text('XL'),

              ],
            ),

            Row(
              children: <Widget>[
                Checkbox( value: selectedSizes.contains("28"), onChanged: (value) => selctedSizeContains("28"), ),
                Text('28'),

                Checkbox( value: selectedSizes.contains("32"), onChanged: (value) => selctedSizeContains("32"), ),
                Text('32'),

                Checkbox( value: selectedSizes.contains("34"), onChanged: (value) => selctedSizeContains("34"), ),
                Text('34'),

                Checkbox( value: selectedSizes.contains("40"), onChanged: (value) => selctedSizeContains("40"), ),
                Text('40'),

                Checkbox( value: selectedSizes.contains("42"), onChanged: (value) => selctedSizeContains("42"), ),
                Text('42'),

              ],
            ),


            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Couleurs:'),
            ),

            CheckboxGroup(
             // orientation: GroupedButtonsOrientation.HORIZONTAL,
              margin: const EdgeInsets.only(left: 25.0),
              checked: _checkedColors,
             // labelStyle: TextStyle(color: Colors.labels[1]),
              labels: <String>[
              "pink","red",'orange', 'yellow', 'green', 'blue', 'indigo', 'purple', 'brown', 'grey', 'white', 'black', 'grey',
              ],
              onSelected: (List selected) {
                setState((){
                 _checkedColors = selected;
                });
                print(_checkedColors);
              },

            ),

            FlatButton(
            color: red,
            textColor: white,
            child: Text("Add product"),
            onPressed: (){
              _validateAndUpload();
            },
          ),

          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>>  getCategoriesDropDown() {
    List<DropdownMenuItem<String>> items = List();
    for(int i = 0; i < categories.length; i++){
      setState(() {
        items.insert(0, DropdownMenuItem(child: Text(categories[i].data['category'],), value: categories[i].data['categoryId']));
      });
    }
    print('getCategoriesDropDown are: ${items.length}');
    return items;
  }

  List<DropdownMenuItem<String>>  getSubCategoriesDropDown() {
    List<DropdownMenuItem<String>> sitems = List();
    for(int i = 0; i < subcategories.length; i++){
      setState(() {
        sitems.insert(0, DropdownMenuItem(child: Text(categories[i].data['subcategory'],), value: categories[i].data['subcategoryId']));
      });
    }
    print('getSubCategoriesDropDown are: ${sitems.length}');
    return sitems;
  }


  List<DropdownMenuItem<String>>  getBrandsDropDown() {
    List<DropdownMenuItem<String>> brandsitems = List();
    for(int i = 0; i < brands.length; i++){
      setState(() {
        brandsitems.insert(0, DropdownMenuItem(child: Text(brands[i].data['brand'],), value: brands[i].data['brand']));
      });
    }
    print('getBrandsDropDown are: ${brandsitems.length}');
    return brandsitems;
  }

  void _getCategories() async{
    List<DocumentSnapshot> data = await _categoryService.getCategories();
    print('_getCategories are: ${data.length}');
    setState(() {
      categories = data;
      _currentCategory = categories[0].data['category'];
      print('from addproduct, _getCategories, _currentCategory :');
      print( categories[0].data['category']);
      categoriesDropDown = getCategoriesDropDown();
      print(categories.length);
    });

  }

  void _getSubCategories() async{
    List<DocumentSnapshot> datas = await _subcategoryService.getSubCategories(_currentCategory);
    print('_getsubCategories are: ${datas.length}');
    setState(() {
      subcategories = datas;
      _currentSubCategory = subcategories[0].data['subcategory'];
      print('from addproduct, _getsubCategories, _currentsubCategory :');
      print( subcategories[0].data['subcategory']);
      subcategoriesDropDown = getSubCategoriesDropDown();
      print(subcategories.length);
    });

  }


  void _getBrands() async{
    List<DocumentSnapshot> datab = await _brandService.getBrands();
    print('_getBrands are : ${datab.length}');
    setState(() {
      brands = datab;
      _currentBrand = brands[0].data['brand'];
      print('from addproduct, _getBrands, _currentBradn :');
      print( brands[0].data['brand']);
      brandDropDown = getBrandsDropDown();
      print(brands.length);
    });

  }

  changeSelectedCategory(String selectedCategory) {
    setState(() {
      _currentCategory = selectedCategory;
    });
  }

  changeSelectedSubCategory(String selectedSubCategory) {
    setState(() {
      _currentSubCategory = selectedSubCategory;
    });
  }

  changeSelectedBrand(String selectedBrand) {
    setState(() {
      _currentBrand = selectedBrand;
    });
  }

  void selctedSizeContains(String s) {
    if(selectedSizes.contains(s)){
    setState(() {
      selectedSizes.remove(s) ;
    });
    }
    else{
      setState(() {
        selectedSizes.insert(0, s);
      });
    }
  }

  void _selectImage(Future<File> pickImage,int num) async{
    File tmpImg = await pickImage;
    switch(num) {
      case 1:
        setState(() {
          _image1 =  tmpImg;
          print(_image1.path.split(".").last);
        });
        break;

      case 2: setState(() => _image2 = tmpImg);
      break;

      case 3: setState(() => _image3 = tmpImg);
      break;

    }
  }

  void _validateAndUpload() async{
    if(_formKey.currentState.validate()){
      setState(() {
        isLoading = true;
      });
      if(_image1 != null && _image2 != null && _image3 != null){
      //    if(selectedSizes.isNotEmpty){
              String imageUrl1;
              String imageUrl2;
              String imageUrl3;
             // final FirebaseStorage _storage = FirebaseStorage.instance;
            //  String fileName = _image1.path.split("/").last;

              StorageReference storageReference = FirebaseStorage.instance.ref();
              StorageReference ref = storageReference.child("products/");


             // final String picture1 = "1${DateTime.now().millisecondsSinceEpoch.toString()}."+_image1.path.split(".").last;
              final String picture1 = "1${DateTime.now().millisecondsSinceEpoch.toString()}";
              StorageUploadTask task1 =  ref.child(picture1).putFile(_image1);
              final String picture2 = "2${DateTime.now().millisecondsSinceEpoch.toString()}";
              StorageUploadTask task2 = ref.child(picture2).putFile(_image2);
              final String picture3 = "3${DateTime.now().millisecondsSinceEpoch.toString()}";
              StorageUploadTask task3 = ref.child(picture3).putFile(_image3);

              StorageTaskSnapshot snapshot1 = await task1.onComplete.then((snapshot) => snapshot);
              StorageTaskSnapshot snapshot2 = await task2.onComplete.then((snapshot) => snapshot);
             // StorageTaskSnapshot snapshot3 = await task3.onComplete.then((snapshot) => snapshot);
              
              task3.onComplete.then((snapshot3) async{
                imageUrl1 = await snapshot1.ref.getDownloadURL();
                imageUrl2 = await snapshot2.ref.getDownloadURL();
                imageUrl3 = await snapshot3.ref.getDownloadURL();

                List<String> imagelist = [imageUrl1, imageUrl2, imageUrl3];

                _productService.uploadProduct(
                  productName: nameController.text,
                  brandId: _currentBrand,
                  brand: _currentBrandName,
                  categoryId: _currentCategoryId,
                  category: _currentCategoryName,
                  subCategoryId: _currentSubCategory,
                  subCategory: _currentSubCategoryName,
                  quantity: int.parse( quantityController.text),
                  sizes: selectedSizes,
                  images: imagelist,
                  price: double.parse(priceController.text),
                  oldprice: double.parse(oldPriceController.text),
                  description: detailsController.text,
                  colors: _checkedColors,
                  tva: int.parse(tvaController.text),
                  remise: double.parse(remiseController.text),
                );
                setState(() {
                  isLoading =false;
                });
                _formKey.currentState.reset();
                Fluttertoast.showToast(msg: 'product added');
              });


//          }
//          else{
//            Fluttertoast.showToast(msg:'Choississez les tailles');
//          }
      }
      else{
        Fluttertoast.showToast(msg: "Vous devez choisisr les trois images");
      }
    }
  }

  Future <void>  _onBrandDropItemSelected(String newValueSelected) async{
    setState(() {
      this._currentBrand = newValueSelected;
    });
    print("_currentBrand: $_currentBrand");

    await  _getBrandName(_currentBrand);
  }

  Future <void> _getBrandName(String id) async{
    DocumentSnapshot data = await _brandService.getBrandById(id);
    print('brand data is : $data');
    setState(() {
      _currentBrandName = data.data["brand"];
      print('from _getBrandName, _getBrandName,  :$_currentBrandName');
    });
  }

  Future <void>  _onShopDropItemSelected(String newValueSelected) async{
    setState(() {
      this._currentCategory = newValueSelected;
    });
    print(_currentCategory);

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


//  Future <void> _getCategoriesName(String id) async{
//    DocumentSnapshot data = await _subcategoryService.getSousCategoriesById(id);
//    print('data is : $data');
//    setState(() {
//      _currentCategoryName = data.data["categoryName"];
//      print('from _getCategoriesName, _currentCategoryName,  :$_currentCategoryName');
//
//      _currentSubCategoryName = data.data["subcategory"];
//      print('from _getCategoriesName, _currentCategoryName,  :$_currentCategoryName');
//    });
//  }



}
