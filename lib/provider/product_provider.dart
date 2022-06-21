import 'package:ecom_admin/db/firestore_helper.dart';
import 'package:ecom_admin/models/product_model.dart';
import 'package:flutter/material.dart';

class ProductProvider extends ChangeNotifier{

  List<String> categoryList=[];
  List<ProductModel> productList=[];

  void getAllCategories(){
    FireStoreHelper.getAllCategories().listen((snapshot) {
      categoryList=List.generate(snapshot.docs.length, (index) => snapshot.docs[index].data()['name']);
      notifyListeners();
    });
  }

  void getAllProducts(){
    FireStoreHelper.getAllProducts().listen((snapshot) {
      productList=List.generate(snapshot.docs.length, (index) => ProductModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  Future<bool> checkAdimins(String email)=>FireStoreHelper.checkAdmins(email);

  Future<void> addNewProduct(ProductModel productModel)=>FireStoreHelper.addNewProduct(productModel);
}