import 'package:flutter/material.dart';
import 'package:bringit/Entities/product.dart';

class ShoppingCart extends StatefulWidget {
  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {

  @override
  void initState() {
    super.initState();
  }

  List<Product> cartList = [
    Product(name: "this and that", price: 25.0),
    Product(name: "this and that", price: 25.0),
  ];

  @override
  Widget build(BuildContext context) {
    return 
    // Container(
    //   alignment: Alignment.topCenter,
      //child: GestureDetector(
      GestureDetector(
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Icon(
              Icons.shopping_cart,
              size: 36.0,
            ),
            if (cartList.length > 0)
              Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: CircleAvatar(
                  radius: 8.0,
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  child: Text(
                    cartList.length.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                    ),
                  ),
                ),
              ),
          ],
        ),
        onTap: () {
          print("click basket");
        },
     // ),
    );
  }
}