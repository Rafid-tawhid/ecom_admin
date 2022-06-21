import 'package:ecom_admin/db/firestore_helper.dart';
import 'package:ecom_admin/provider/product_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewProducts extends StatefulWidget {
  static const String routeName='/all_products';

  @override
  State<ViewProducts> createState() => _ViewProductsState();
}

class _ViewProductsState extends State<ViewProducts> {
  late ProductProvider _productProvider;


  @override
  void didChangeDependencies() {
    _productProvider=Provider.of<ProductProvider>(context,listen: true);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('All Products'),),
      body: ListView.builder(
        itemCount: _productProvider.productList.length,
        itemBuilder: (context,index){
          final product=_productProvider.productList[index];
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: ListTile(
              tileColor: Colors.grey.shade200,
              title: Text(product.name!),
              leading: CircleAvatar(
                radius: 30,
                  child: ClipOval(
                    child: fadedImageWidget(product.imageDownloadUrl!)
                  ),
                ),
              trailing: Text(product.price!.toString()+'\$'),
            ),
          );
        },
      )
    );
  }

  Widget fadedImageWidget(String url){
    return FadeInImage.assetNetwork(
      fadeInDuration: Duration(seconds: 3),
      fadeInCurve: Curves.ease,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity ,
      placeholder: 'images/pc.jpg',
      image: url,
    );
  }
}
