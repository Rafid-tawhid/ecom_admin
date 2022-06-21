 import 'package:ecom_admin/auth/auths.dart';
import 'package:ecom_admin/pages/dashboard_page.dart';
import 'package:ecom_admin/pages/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LauncherPage extends StatefulWidget {
   static const String routeName='/launcher';

   @override
   State<LauncherPage> createState() => _LauncherPageState();
 }

 class _LauncherPageState extends State<LauncherPage> {
   @override
   void initState() {
     Future.delayed(Duration.zero,(){
       if(FirebaseAuthService.currentUser ==null){
         Navigator.pushReplacementNamed(context, LoginPage.routeName);
       }
       else{
         Navigator.pushReplacementNamed(context, DashboardPage.routeName);
       }
     });
     super.initState();
   }


   @override
   Widget build(BuildContext context) {
     return Scaffold(
       body: Center(
         child: CircularProgressIndicator(),
       ),
     );
   }


}
