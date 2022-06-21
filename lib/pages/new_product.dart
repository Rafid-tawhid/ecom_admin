import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_admin/models/product_model.dart';
import 'package:ecom_admin/provider/product_provider.dart';
import 'package:ecom_admin/utility/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../utility/helper.dart';

class NewProductPage extends StatefulWidget {
  static const String routeName='/new_product';

  @override
  State<NewProductPage> createState() => _NewProductPageState();
}

class _NewProductPageState extends State<NewProductPage> {
  late ProductProvider _productProvider;
  String? category;
  DateTime? _dateTime;
  ProductModel _productModel=ProductModel();
  ImageSource _imageSource=ImageSource.camera;
  String? _imagePath;
  bool isSaving=false;
  final _fromKey=GlobalKey<FormState>();





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Product '),
      actions: [
        IconButton(onPressed: _saveProduct, icon: Icon(Icons.save))
      ],),
      body: Stack(

        children: [
          if(isSaving)Center(child: CircularProgressIndicator()),
          Form(
            key: _fromKey,
            child: ListView(
              padding: EdgeInsets.all(12),
              children: [
                TextFormField(
                  onSaved: (value){
                    _productModel.name=value;
                  },
                  keyboardType: TextInputType.emailAddress,
                  validator: (value){
                    if(value==null && value!.isEmpty){
                      return 'This Field is Required';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      label: Text('Product Name'),
                      border: OutlineInputBorder()
                  ),
                ),
                SizedBox(height: 10,),
                TextFormField(
                  onSaved: (value){
                    _productModel.description=value;
                  },
                  keyboardType: TextInputType.emailAddress,
                  validator: (value){
                    if(value==null && value!.isEmpty){
                      return 'This Field is Required';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      label: Text('Product Description'),
                      border: OutlineInputBorder()
                  ),
                ),
                SizedBox(height: 10,),
                TextFormField(
                  onSaved: (value){
                    _productModel.price=num.parse(value!);
                  },
                  keyboardType: TextInputType.number,
                  validator: (value){
                    if(value==null && value!.isEmpty){
                      return 'This Field is Required';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      label: Text('Product Price'),
                      border: OutlineInputBorder()
                  ),
                ),
                SizedBox(height: 10,),
                TextFormField(
                  onSaved: (value){
                    _productModel.stock=int.parse(value!);
                  },
                  keyboardType: TextInputType.number,
                  validator: (value){
                    if(value==null && value!.isEmpty){
                      return 'This Field is Required';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      label: Text('Quantity'),
                      border: OutlineInputBorder()
                  ),
                ),
                SizedBox(height: 10,),
                DropdownButtonFormField<String>(
                  hint: Text('Select Category'),
                  value: category,
                  items: _productProvider.categoryList.map((cat) =>
                      DropdownMenuItem(child: Text(cat),value: cat,)).toList(),
                  onChanged: (val){
                    setState((){
                      category=val;
                    });
                    _productModel.category=category;
                  },
                  validator: (value){
                    if(value==null && value!.isEmpty){
                      return 'Category is Required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10,),
                Card(
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton.icon(
                          icon: Icon(Icons.date_range),
                          label: Text('Select Date'),
                          onPressed: _showDatePicker,
                        ),
                        Text(_dateTime==null? 'No date Chosen':getFormattedDate(_dateTime!,'dd/MM/yyyy')),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        child: _imagePath==null?Image.asset('images/pc.jpg'):Image.file(File(_imagePath!),width: 100,height: 100,fit: BoxFit.cover,),

                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(onPressed: (){
                            _imageSource=ImageSource.camera;
                            _pickImage();
                          }, child: Text('Camera')),
                          ElevatedButton(onPressed: (){
                            _imageSource=ImageSource.gallery;
                            _pickImage();
                          }, child: Text('Gallery')),
                        ],
                      ),
                    ],
                  ),
                )


              ],
            ),
          ),
        ],
      ),
    );
  }

  void _saveProduct() async{
    final isConnected=await isConnectedToInterNet();
    if(isConnected){

      if(_fromKey.currentState!.validate()){
        _fromKey.currentState!.save();
        if(_dateTime==null){
          showMessage(context, 'Please Select a Date');
          return;
        }
        if(_imagePath==null){
          showMessage(context, 'Please Select an Image');
          return;
        }
        setState((){
          isSaving=true;
        });
        print(_productModel);
        _uploadImageAndSaveProduct();

      }
    }
    else {
      showMessage(context, 'No Internet Connection');
    }

  }

  @override
  void didChangeDependencies() {
    _productProvider=Provider.of<ProductProvider>(context,listen: true);
    super.didChangeDependencies();
  }

  void _showDatePicker() async {
  final dt= await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year),
        lastDate: DateTime.now());
  if(dt!=null){
    setState((){
      _dateTime=dt;
    });
    _productModel.purchaseDate= Timestamp.fromDate(_dateTime!);
  }

  }

  void _pickImage() async{
    final pickedFile=await ImagePicker().pickImage(source: _imageSource,imageQuality: 60);
    if(pickedFile!=null){
      setState((){
        _imagePath=pickedFile.path;
      });
      _productModel.localImagePath=_imagePath;
    }
  }

  void _uploadImageAndSaveProduct() async {
    final uploadFile=File(_imagePath!);
    final imageName='Product${DateTime.now()}';
    final photoRef=FirebaseStorage.instance.ref().child('$photoDirectory/$imageName');
    try {
      final uploadTask=photoRef.putFile(uploadFile);
      final snapshot= await uploadTask.whenComplete(() {
        showMessage(context, 'Upload Completed');
      });
      final dlUrl= await snapshot.ref.getDownloadURL();
      _productModel.imageDownloadUrl=dlUrl;
      _productModel.imageName=imageName;
      _productProvider.addNewProduct(_productModel).then((_){
        setState((){
          isSaving=false;
          Navigator.pop(context);
        });
      });

    }
    catch(error){
      setState((){
        isSaving=false;
      });
      Navigator.pop(context);
      showMessage(context, 'Failed to Upload');
      throw error;
    }
    }
}
