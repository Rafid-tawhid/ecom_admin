import 'package:ecom_admin/auth/auths.dart';
import 'package:ecom_admin/pages/login_page.dart';
import 'package:ecom_admin/pages/new_product.dart';
import 'package:ecom_admin/pages/view_products.dart';
import 'package:ecom_admin/provider/product_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  static const String routeName='/dashboard';

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  late ProductProvider _productProvider;


  @override
  void didChangeDependencies() {
    _productProvider=Provider.of<ProductProvider>(context,listen: false);
    _productProvider.getAllCategories();
    _productProvider.getAllProducts();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(
              icon: Icon(Icons.logout_outlined),
            onPressed: (){
              FirebaseAuthService.logOutAdmin().then((_) => Navigator.pushReplacementNamed(context, LoginPage.routeName));
            }
          )
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        children: [
          ElevatedButton(onPressed: (){
            Navigator.pushNamed(context, NewProductPage.routeName);
          }, child: Text('Add Product')),
          ElevatedButton(onPressed: (){
            Navigator.pushNamed(context, ViewProducts.routeName);
          }, child: Text('View Product')),
          ElevatedButton(onPressed: (){
            Navigator.pushNamed(context, NewProductPage.routeName);
          }, child: Text('Add Product')),
          ElevatedButton(onPressed: (){
            Navigator.pushNamed(context, NewProductPage.routeName);
          }, child: Text('Add Product')),
          ElevatedButton(onPressed: (){
            Navigator.pushNamed(context, NewProductPage.routeName);
          }, child: Text('Add Product')),
          ElevatedButton(onPressed: (){
            Navigator.pushNamed(context, NewProductPage.routeName);
          }, child: Text('Add Product'))
        ],
      ),
    );
  }
}
