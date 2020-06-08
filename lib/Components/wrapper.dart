import 'package:bringit/Components/home_page.dart';
import 'package:bringit/Entities/user.dart';
import 'package:bringit/Services/user_database.dart';
import 'package:flutter/material.dart';
import 'package:bringit/Components/Authenticate/authenticate.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    //print(user);
    return user == null ? Authenticate() : Home(user: user);
    //return Home();
  }
}