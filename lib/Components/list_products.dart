import 'package:bringit/Entities/product.dart';
import 'package:flutter/material.dart';
import 'package:bringit/Utils/constants.dart';
import 'package:bringit/Components/shopping_cart.dart';

class ListProducts extends StatefulWidget {
  @override
  _ListProductsState createState() => _ListProductsState();
}

class _ListProductsState extends State<ListProducts> {

  @override
  void initState() {
    super.initState();
  }

  List<Product> listProduct = [
    Product(name: "Pain au chocolat", price: 25.0),
    Product(name: "Pain au raisin", price: 35.0),
    Product(name: "Crème fraiche", price: 45.0),
    Product(name: "Lait de la vache", price: 55.0),
    Product(name: "Pain au rhum", price: 65.0),
    Product(name: "Pain baguette", price: 5.0),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Constants['primary_color'],
        centerTitle: true,
        elevation: 0.0,
        title: Row(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Text(
                Constants['choose your products'],
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 2.0,
                  fontSize: 15.0
                )
              ),
            ),
            Expanded(
              flex: 1,
              child: ShoppingCart()
            ),
          ]
        )
      ),
      body: Column(
        children: <Widget>[
          Card(
            child: ListTile(
              onTap: () {},
              title: Text("Restaurent des AL3Cs"),
              leading: Icon(
                Icons.restaurant,
                color: Colors.amber,
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Expanded(
            child: ListView.builder(
              itemCount: listProduct.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 3.0),
                  child: Card(
                    child: ListTile(
                      onTap: () {},
                      title: Text(listProduct[index].name),
                      leading: Icon(
                        Icons.shopping_basket,
                        color: Constants['primary_color'],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ]
      ),
    );
  }
}