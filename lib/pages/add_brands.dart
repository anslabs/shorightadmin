import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shorightadmin/db/brand.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class AddBrand extends StatefulWidget {
  @override
  _AddBrandState createState() => _AddBrandState();
}

class _AddBrandState extends State<AddBrand> {

  TextEditingController brandController = TextEditingController();

  GlobalKey<FormState> _brandFormKey = GlobalKey();

  BrandService _brandService = BrandService();
  bool isLoading = false;
  File _image1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black54),
        //leading: Icon(Icons.close, color: Colors.black,),
        title: Text("Add brand", style: TextStyle(color: Colors.black),),
      ),
      body:  Form(
        key: _brandFormKey,
        child: isLoading? Center(child: CircularProgressIndicator()): ListView(
          children: <Widget>[

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlineButton(
                borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.0),
                onPressed: (){_selectImage(ImagePicker.pickImage(source: ImageSource.gallery));},
                child:_image1 == null?
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 50, 14, 50),
                  child: Icon(Icons.add, color: Colors.grey,),
                )
                    :Image.file(_image1, fit: BoxFit.fill, width: double.infinity, height: 350.0,),
              ),
            ),


            Padding(
              padding: const EdgeInsets.all(8.0),
              child:  TextFormField(
                controller: brandController,
                validator: (value){
                  if(value.isEmpty){
                    return 'brand cannot be empty';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    hintText: "add brand"
                ),
              ),
            ),

            FlatButton(

                color: Colors.red,
                textColor: Colors.white,
                onPressed: (){
                  setState(() {
                    isLoading = true;
                  });

                  if (_image1 != null) {

                    String imageUrl1;
                    StorageReference storageReference = FirebaseStorage.instance.ref();
                    StorageReference ref = storageReference.child("brands/");
                    final String picture1 = "${DateTime.now().millisecondsSinceEpoch.toString()}";
                    StorageUploadTask task1 =  ref.child(picture1).putFile(_image1);

                    task1.onComplete.then((snapshot1) async {
                      imageUrl1 = await snapshot1.ref.getDownloadURL();

                      String imagesb = imageUrl1;
                      print("imagesb: $imagesb");
                      if(brandController.text != null){

                        setState(() {
                          isLoading = false;
                        });
                        print("imagesb: imagesb");

                        _brandService.createBrand(brandController.text, imagesb);
                        Fluttertoast.showToast(msg: 'brand created');
                      }
                      else{
                        setState(() {
                          isLoading = false;
                        });

                        print("imagesb: 2imagesb");

                        Fluttertoast.showToast(msg: 'brand created');
                      }
                    });
                  }
                  setState(() {
                    isLoading = false;
                  });

                },
                child: Text('ADD')
            ),

          ],
        ),
      ),
    );
  }

  void _selectImage(Future<File> pickImage) async{
    File tmpImg = await pickImage;
    setState(() {
      _image1 =  tmpImg;
      print(_image1.path.split(".").last);
    });
  }

}
