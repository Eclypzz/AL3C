import 'package:bringit/Entities/product.dart';
import 'package:flutter/material.dart';
import 'package:bringit/Utils/constants.dart';

class ShoppingList extends StatefulWidget {
  @override
  _ShoppingListState createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {

  List<Product> listProduct = [
    
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    listProduct = listProduct.length > 0 ? listProduct : ModalRoute.of(context).settings.arguments;

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
                Constants['your_shopping_list'],
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 2.0,
                  fontSize: 15.0
                )
              ),
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
                    child: Row(
                      children :<Widget>[
                        Expanded(
                          flex: 5,
                          child: ListTile(
                            onTap: () {},
                            title: Text(''),
                            leading: Icon(
                              Icons.shopping_basket,
                              color: Constants['primary_color'],
                            ),
                        ),
                        ),
                        Expanded(
                          flex: 1,
                          child: IconButton(
                            icon: Icon(Icons.delete), 
                            onPressed: () {
                              print("deleted");
                            }
                          ),
                        )
                      ]
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