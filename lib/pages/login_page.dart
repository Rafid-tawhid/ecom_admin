import 'package:ecom_admin/auth/auths.dart';
import 'package:ecom_admin/pages/dashboard_page.dart';
import 'package:ecom_admin/provider/product_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  static const String routeName='/login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _fromKey=GlobalKey<FormState>();
  String? _email;
  String? _pass;
  String errMsg='';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login Page'),),
      body: Center(
        child: Form(
          key: _fromKey,
          child: ListView(
            padding: EdgeInsets.all(8),
            shrinkWrap: true,
            children: [
              Center(child: Padding(
                padding: const EdgeInsets.all(38.0),
                child: Text('Admin Login',style: TextStyle(fontSize: 24),),
              ),),
               TextFormField(
                 onSaved: (value){
                   _email=value;
                 },
                 keyboardType: TextInputType.emailAddress,
                 validator: (value){
                   if(value==null && value!.isEmpty){
                     return 'This Field is Required';
                   }
                   return null;
                 },
                 decoration: InputDecoration(
                   label: Text('Email Address'),
                   border: OutlineInputBorder()
                 ),
               ),
              SizedBox(height: 10,),
              TextFormField(
                obscureText: true,
                onSaved: (value){
                  _pass=value;
                },
                keyboardType: TextInputType.visiblePassword,
                validator: (value){
                  if(value==null && value!.isEmpty){
                    return 'This Field is Required';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    label: Text('Password'),
                    border: OutlineInputBorder()
                ),
              ),
              SizedBox(height: 40,),
              ElevatedButton(onPressed: _loginAdmin, child: Text('Login ')),
              SizedBox(height: 10,),
              Center(child: Text(errMsg,style: TextStyle(color: Colors.redAccent),)),
            ],
          ),
        ),
      ),
    );
  }

  void _loginAdmin() async{
    if(_fromKey.currentState!.validate()){
      _fromKey.currentState!.save();
      try{
       final user=await FirebaseAuthService.loginAdmin(_email!, _pass!);
       if(user!=null){
          final isAdmin=await Provider.of<ProductProvider>(context,listen: false).checkAdimins(_email!);
          if(isAdmin){
            Navigator.pushReplacementNamed(context, DashboardPage.routeName);
          }
          setState((){
            errMsg='You are Not An Admin';
          });

       }

      }on FirebaseAuthException catch(e){
        setState((){
          errMsg=e.message!;
        });
      }
    }
  }
}
