import 'package:ecom_admin/pages/dashboard_page.dart';
import 'package:ecom_admin/pages/launcher_page.dart';
import 'package:ecom_admin/pages/login_page.dart';
import 'package:ecom_admin/pages/new_product.dart';
import 'package:ecom_admin/pages/view_products.dart';
import 'package:ecom_admin/provider/product_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=>ProductProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LauncherPage(),
        routes: {
          LauncherPage.routeName:(context)=>LauncherPage(),
          LoginPage.routeName:(context)=>LoginPage(),
          NewProductPage.routeName:(context)=>NewProductPage(),
          DashboardPage.routeName:(context)=>DashboardPage(),
          ViewProducts.routeName:(context)=>ViewProducts(),
        },
      ),
    );
  }
}



