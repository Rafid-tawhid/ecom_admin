import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel{
  String? id;
  String? name;
  String? category;
  num? price;
  String? localImagePath;
  String? imageDownloadUrl;
  String? description;
  int? stock;
  bool isAvailable;
  Timestamp? purchaseDate;
  String? imageName;

  ProductModel(
      {this.id,
      this.name,
      this.category,
      this.price,
      this.localImagePath,
      this.imageDownloadUrl,
      this.description,
      this.stock=1,
      this.isAvailable=true,
      this.purchaseDate,
      this.imageName});

  Map<String,dynamic> toMap(){
    var map=<String,dynamic>{
      'id':id,
      'name':name,
      'category':category,
      'price':price,
      'localImagePath':localImagePath,
      'imageDownloadUrl':imageDownloadUrl,
      'description':description,
      'stock':stock,
      'isAvailable':isAvailable,
      'timestamp':purchaseDate,
      'imageName':imageName,
    };
    return map;
  }

  factory ProductModel.fromMap(Map<String,dynamic> map)=>ProductModel(
    id:map['id'],
    name:map['name'],
    category: map['category'],
    price: map['price'],
    localImagePath: map['localImagePath'],
    imageDownloadUrl: map['imageDownloadUrl'],
    description: map['description'],
    stock: map['stock'],
    isAvailable: map['isAvailable'],
    purchaseDate: map['purchaseDate'],
    imageName: map['imageName'],
  );

  @override
  String toString() {
    return 'ProductModel{id: $id, name: $name, category: $category, price: $price, localImagePath: $localImagePath, imageDownloadUrl: $imageDownloadUrl, description: $description, stock: $stock, isAvailable: $isAvailable, purchaseDate: $purchaseDate, imageName: $imageName}';
  }
}