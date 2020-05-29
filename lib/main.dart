import 'package:bringit/Components/home_page.dart';
import 'package:bringit/Components/loading.dart';
import 'package:flutter/material.dart';


void main() => runApp(MaterialApp(
  //home: Home(),
  initialRoute: '/',
  routes: {
    '/': (context) => Loading(),
    '/home': (context) => Home(),
  },
));
