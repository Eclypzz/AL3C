import 'package:bringit/Components/Authenticate/sign_in.dart';
import 'package:bringit/Components/home_page.dart';
import 'package:bringit/Components/loading.dart';
import 'package:bringit/Entities/user.dart';
import 'package:bringit/Services/auth.dart';
import 'package:flutter/material.dart';
import 'package:bringit/Components/list_products.dart';
import 'package:bringit/Components/loading_simple.dart';
import 'package:bringit/Components/shopping_list.dart';
import 'package:bringit/Components/wrapper.dart';
import 'package:provider/provider.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        home: Wrapper(),
        //initialRoute: '/login',
        routes: {
          '/ld': (context) => Loading(),
          '/lds': (context) => LoadingSimple(),
          '/home': (context) => Home(),
          '/list_produtcs': (context) => ListProducts(),
          '/shopping_list': (context) => ShoppingList(),
          '/login': (context) => SignIn(),
        },
      ),
    );
  }
}

//Navigator.pushedReplacementNamed