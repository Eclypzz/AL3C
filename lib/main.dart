import 'package:bringit/Components/Authenticate/sign_in.dart';
import 'package:bringit/Components/Command/choose_product.dart';
import 'package:bringit/Components/Command/choose_shop.dart';
import 'package:bringit/Components/Command/your_command.dart';
import 'package:bringit/Components/home_page.dart';
import 'package:bringit/Entities/user.dart';
import 'package:bringit/Services/auth.dart';
import 'package:bringit/Services/user_database.dart';
import 'package:flutter/material.dart';
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
        home: StreamProvider<List<User>>.value(value: UserDatabaseService().getUserStream, child: Wrapper()),
        //initialRoute: '/login',
        routes: {
          '/home': (context) => Home(),
          '/chose_product': (context) => ChooseProduct(),
          '/shopping_list': (context) => ShoppingList(),
          '/login': (context) => SignIn(),
          '/your_command': (context) => YourCommand(),
          '/create_command': (context) => CreateCommand(),
        },
      ),
    );
  }
}

//Navigator.pushedReplacementNamed