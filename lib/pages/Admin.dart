import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shorightadmin/db/brand.dart';
import 'package:shorightadmin/db/category.dart';
import 'package:shorightadmin/db/subcategory.dart';
import 'package:shorightadmin/db/test.dart';
import 'package:shorightadmin/pages/AddProduct.dart';
import 'package:shorightadmin/pages/add_brands.dart';
import 'package:shorightadmin/pages/add_category.dart';
import 'package:shorightadmin/pages/add_subcategory.dart';

enum Page { dashboard, manage }

class Admin extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {

  Page _selectedPage = Page.dashboard;

  MaterialColor active = Colors.red;
  MaterialColor notActive = Colors.grey;

  TextEditingController categoryController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  TextEditingController subcategoryController = TextEditingController();
  TextEditingController testController = TextEditingController();

  GlobalKey<FormState> _categoryFormKey = GlobalKey();
  GlobalKey<FormState> _subcategoryFormKey = GlobalKey();
  GlobalKey<FormState> _brandFormKey = GlobalKey();
  GlobalKey<FormState> _testFormKey = GlobalKey();

  TestService _testService = TestService();
  BrandService _brandService = BrandService();
  CategoryService _categoryService = CategoryService();
  SubCategoryService _subcategoryService = SubCategoryService();

  List<DocumentSnapshot> categories = <DocumentSnapshot>[];
  List<DropdownMenuItem<String>> categoriesDropDown = <DropdownMenuItem<String>>[];
  String _currentCategory;


  @override
  void initState() {
    // TODO: implement initState
    //_getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          title: Row(
            children: <Widget>[
              Expanded(
                  child: FlatButton.icon(
                      onPressed: () {
                        setState(() => _selectedPage = Page.dashboard);
                      },
                      icon: Icon(
                        Icons.dashboard,
                        color: _selectedPage == Page.dashboard
                            ? active
                            : notActive,
                      ),
                      label: Text('Dashboard'))),
              Expanded(
                  child: FlatButton.icon(
                      onPressed: () {
                        setState(() => _selectedPage = Page.manage);
                      },
                      icon: Icon(
                        Icons.sort,
                        color:
                        _selectedPage == Page.manage ? active : notActive,
                      ),
                      label: Text('Manage'))),
            ],
          ),
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        body: _loadScreen(),
    );
  }

  Widget _loadScreen() {
    switch (_selectedPage) {
      case Page.dashboard:
        return Column(
          children: <Widget>[
            ListTile(
              subtitle: FlatButton.icon(
                onPressed: null,
                icon: Icon(
                  Icons.attach_money,
                  size: 30.0,
                  color: Colors.green,
                ),
                label: Text('12,000',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30.0, color: Colors.green)),
              ),
              title: Text(
                'Revenue',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0, color: Colors.grey),
              ),
            ),
            Expanded(
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ListTile(
                          title: FlatButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.people_outline),
                              label: Text("Users")),
                          subtitle: Text(
                            '7',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 30.0),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ListTile(
                          title: FlatButton.icon(
                              padding: EdgeInsets.all(1.0),
                              onPressed: null,
                              icon: Icon(Icons.category),
                              label: Text("Categories")),
                          subtitle: Text(
                            '23',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 30.0),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ListTile(
                          title: FlatButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.track_changes),
                              label: Text("Producs")),
                          subtitle: Text(
                            '120',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 30.0),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ListTile(
                          title: FlatButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.tag_faces),
                              label: Text("Sold")),
                          subtitle: Text(
                            '13',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 30.0),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ListTile(
                          title: FlatButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.shopping_cart),
                              label: Text("Orders")),
                          subtitle: Text(
                            '5',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 30.0),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ListTile(
                          title: FlatButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.close),
                              label: Text("Return")),
                          subtitle: Text(
                            '0',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 30.0),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ListTile(
                          title: FlatButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.close),
                              label: Text("Return")),
                          subtitle: Text(
                            '0',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 30.0),
                          )),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ListTile(
                          title: FlatButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.close),
                              label: Text("Return")),
                          subtitle: Text(
                            '0',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 30.0),
                          )),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ListTile(
                          title: FlatButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.close),
                              label: Text("Return")),
                          subtitle: Text(
                            '0',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 30.0),
                          )),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ListTile(
                          title: FlatButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.close),
                              label: Text("Return")),
                          subtitle: Text(
                            '0',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 30.0),
                          )),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ListTile(
                          title: FlatButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.close),
                              label: Text("Return")),
                          subtitle: Text(
                            '0',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 30.0),
                          )),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ListTile(
                          title: FlatButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.close),
                              label: Text("Return")),
                          subtitle: Text(
                            '0',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 30.0),
                          )),
                    ),
                  ),




                ],
              ),
            ),
          ],
        );
        break;
      case Page.manage:
        return ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.add),
              title: Text("Add product"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => AddProduct()));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.change_history),
              title: Text("Products list"),
              onTap: () {},
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.add_circle),
              title: Text("Add category"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => AddCategory()));
                //  _categoryAlert();
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.category),
              title: Text("Category list"),
              onTap: () {},
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.add_circle),
              title: Text("Ajouter sous catégorie"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => AddSubCategory()));
                // _subcategoryAlert();
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.library_books),
              title: Text("liste des sous catégories"),
              onTap: () {},
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.add_circle_outline),
              title: Text("Add brand"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => AddBrand()));
                // _brandAlert();
              },
            ),

            Divider(),
            ListTile(
              leading: Icon(Icons.library_books),
              title: Text("brand list"),
              onTap: () {},
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.add_circle_outline),
              title: Text("Add test"),
              onTap: () {
                _testAlert();
              },
            ),

            Divider(),

          ],
        );
        break;
      default:
        return Container();
    }
  }

  void _categoryAlert() {
    var alert = new AlertDialog(
      content: Form(
        key: _categoryFormKey,
        child: TextFormField(
          controller: categoryController,
          validator: (value){
            if(value.isEmpty){
              return 'category cannot be empty';
            }
            return null;
          },
          decoration: InputDecoration(
              hintText: "add category"
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: (){
              if(categoryController.text != null){
                _categoryService.createCategory(categoryController.text, "n");
              }
              Fluttertoast.showToast(msg: 'category created');
              Navigator.pop(context);
            },
            child: Text('ADD')
        ),
        FlatButton(
          onPressed: (){
            Navigator.pop(context);
          },
          child: Text('CANCEL'),
        ),

      ],
    );

    showDialog(context: context, builder: (_) => alert);
  }

  void _subcategoryAlert() {
    var alert = new AlertDialog(
      content: Form(
        key: _subcategoryFormKey,
        child: ListView(
          children: <Widget>[

            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Catégorie", style: TextStyle(color: Colors.red),),
                ),
                DropdownButton(
                  items: categoriesDropDown,
                  onChanged: changeSelectedCategory,
                  value: _currentCategory,
                ),
              ],
            ),

            TextFormField(

              controller: subcategoryController,
              validator: (value){
                if(value.isEmpty){
                  return 'category cannot be empty';
                }
                return null;
              },
              decoration: InputDecoration(
                  hintText: "sous catégorie",
                labelText: "sous catégorie"
              ),
            ),

          ],
        ),

      ),
      actions: <Widget>[
        FlatButton(
            onPressed: (){

            },
            child: Text('Ajouter')
        ),
        FlatButton(
          onPressed: (){
            Navigator.pop(context);
          },
          child: Text('Annuler'),
        ),

      ],
    );

    showDialog(context: context, builder: (_) => alert);
  }

  void _brandAlert() {
    var alert = new AlertDialog(
      content: Form(
        key: _brandFormKey,
        child: TextFormField(
          controller: brandController,
          validator: (value){
            if(value.isEmpty){
              return 'category cannot be empty';
            }
            return null;
          },
          decoration: InputDecoration(
              hintText: "add brand"
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: (){
            if(brandController.text != null){
              _brandService.createBrand(brandController.text, " ");
            }
            Fluttertoast.showToast(msg: 'brand added');
            Navigator.pop(context);
          },
          child: Text('ADD'),
        ),
        FlatButton(onPressed: (){
          Navigator.pop(context);
        },
          child: Text('CANCEL'),
        ),

      ],
    );

    showDialog(context: context, builder: (_) => alert);
  }

  void _testAlert() {
    var alert = new AlertDialog(
      content: Form(
        key: _testFormKey,
        child: TextFormField(
          controller: testController,
          validator: (value){
            if(value.isEmpty){
              return 'test cannot be empty';
            }
            return null;
          },
          decoration: InputDecoration(
              hintText: "add test"
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: (){
            if(testController.text != null){
              _testService.createTest(testController.text);
            }
            Fluttertoast.showToast(msg: 'test added');
            Navigator.pop(context);
          },
          child: Text('ADD'),
        ),
        FlatButton(onPressed: (){
          Navigator.pop(context);
        },
          child: Text('CANCEL'),
        ),

      ],
    );

    showDialog(context: context, builder: (_) => alert);
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

  changeSelectedCategory(String selectedCategory) {
    setState(() {
      _currentCategory = selectedCategory;
    });
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


}
