import 'package:bringit/Components/Command/list_products.dart';
import 'package:bringit/Entities/product.dart';
import 'package:bringit/Services/product_partner_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ChooseProduct extends StatefulWidget {
  @override
  _ChooseProductState createState() => _ChooseProductState();
}

class _ChooseProductState extends State<ChooseProduct> {
  Map arguments = {};
  
  @override
  Widget build(BuildContext context) {

    arguments = ModalRoute.of(context).settings.arguments;
    
    return StreamProvider<List<Product>>.value(
      value: ProductPartnerDatabaseService(documentID: arguments['idPartner']).productsFromStream,
      child: ListProducts(),
    );
  }
}