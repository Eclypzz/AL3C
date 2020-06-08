import 'package:bringit/Components/loading_simple.dart';
import 'package:bringit/Entities/command.dart';
import 'package:bringit/Entities/product.dart';
import 'package:bringit/Services/auth.dart';
import 'package:bringit/Services/command_database.dart';
import 'package:bringit/Services/product_database.dart';
import 'package:flutter/material.dart';
import 'package:bringit/Utils/constants.dart';
import 'package:bringit/Components/Command/shopping_cart.dart';
import 'package:provider/provider.dart';
//import 'dart:convert';

class ListProducts extends StatefulWidget {
  @override
  _ListProductsState createState() => _ListProductsState();
}

class _ListProductsState extends State<ListProducts> {
  bool loading = false;
  List<Product> listProduct;
  List<String> listCategories;
  List<Product> listShopping;
  Map<String,List<Product>> mapProductCategory;
  ProductDatabaseService pdbs;
  //Map<String, int> currentListCmd;
  String currentCategory;
  Map arguments;
  Command command;

  final AuthService _auth = AuthService();
  
  @override
  void initState() {
    super.initState();
    listProduct = [];
    listCategories = [];
    currentCategory = Constants['choose_your_products'];
    //listCategories.add(currentCategory);
    mapProductCategory = {};
    command = Command(idDemandeur: '', idRepondeur: '', listeCommande: Map(), totalEnEuro: 0.0, listCommandeSub: Map());

  }
  
  // show list or none
  Widget _showListOrNone(){
    return listProduct.length == 0 ?
      Padding(
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 3.0),
        child: Card(
          child: ListTile(
            onTap: () {},
            title: Text("Aucun produit est disponible dans ce magasin"),
            leading: Icon(
              Icons.sentiment_dissatisfied,
              color: Constants['primary_color'],
            ),
          ),
        ),
      )
      :
      Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Expanded(
          flex: 3,
          child: Container(
            alignment: Alignment.center,
            child: DropdownButton<String>(
              value: currentCategory,
              items: (<String>[Constants['choose_your_products']]+listCategories).map<DropdownMenuItem<String>>((category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (category) {
                setState(() {
                  currentCategory = category;
                });
              }
            ),
          ),
        ),
        SizedBox(width: 10.0),
        Expanded(flex: 1,child: Text('Total')),
        Expanded(flex: 1,child: Text('${command.totalEnEuro.toStringAsFixed(2).toString()} €', style: TextStyle(fontWeight: FontWeight.bold))),
      ]
      );
  }
  
  // show minus button
  bool _showMinusButton(int index){
    return ( command.listeCommande[mapProductCategory[currentCategory][index]] != null &&
             command.listeCommande[mapProductCategory[currentCategory][index]] != 0 );
  }

  // shopping cart 
  Widget _shoppingCart( Product product, int quant, int index){
      return GestureDetector(
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Icon(
              Icons.shopping_cart,
              size: 36.0,
            ),
            if (_showMinusButton(index))
              Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: CircleAvatar(
                  radius: 8.0,
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  child: Text(
                    quant.toString(),
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
  @override
  Widget build(BuildContext context) {

    listProduct = Provider.of<List<Product>>(context);
    arguments = ModalRoute.of(context).settings.arguments;
    pdbs = ProductDatabaseService(documentID: arguments['idPartner']);
    mapProductCategory = {};
    
    listCategories = pdbs.getCategories(listProduct);
    if (listProduct != null){
      listCategories.map((category) => {
        mapProductCategory.putIfAbsent(category, () => pdbs.getProductsFromCategory(category, listProduct)),
      }).toList();
    }

    command.setDemander(arguments['idUser']);
    command.setMagasin(arguments['idPartner']);

    //command.listeCommande == null ? print(true) : print(false);
    // list products
    Widget _listProducts(){
      return listProduct.length == 0 ? 
      Card() 
      :
      currentCategory == Constants['choose_your_products'] ?
      Card()
      :
      Expanded(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 3.0),
          child: Card(
            child: Expanded(
              child: 
              ListView.builder(
                shrinkWrap: true,
                itemCount: mapProductCategory[currentCategory].length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.all(0.0),
                    child: Card(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: ListTile(
                              onTap: () {},
                              title: Row(
                                children: <Widget>[
                                  Expanded(child: Text(mapProductCategory[currentCategory][index].nom), flex: 3),
                                  SizedBox(width: 20.0,),
                                  Expanded(child: Text('${mapProductCategory[currentCategory][index].prix.toString()} €'), flex: 1),
                                  SizedBox(width: 5.0,),
                                  Text('/ ${mapProductCategory[currentCategory][index].unite}'),
                                ]
                                ),
                              leading: _shoppingCart(
                                mapProductCategory[currentCategory][index], 
                                command.listeCommande[mapProductCategory[currentCategory][index]],
                                index
                                ),
                              trailing: IconButton(
                                onPressed: () {
                                  setState(() {
                                    if(command.listeCommande[mapProductCategory[currentCategory][index]] == null){
                                      command.listeCommande[mapProductCategory[currentCategory][index]] = 0;
                                      command.listCommandeSub[mapProductCategory[currentCategory][index].id] = 0;
                                    }
                                    command.listeCommande[mapProductCategory[currentCategory][index]] += 1;
                                    command.listCommandeSub[mapProductCategory[currentCategory][index].id] += 1;
                                    command.totalEnEuro += mapProductCategory[currentCategory][index].prix;
                                    
                                  });
                                },
                                icon: Icon(Icons.add),
                              )
                            ),
                          ),
                          //condition to show remove icon 
                          if (_showMinusButton(index))
                            IconButton(
                              icon: Icon(Icons.remove_circle),
                              onPressed: () {
                                setState(() {
                                  command.listeCommande[mapProductCategory[currentCategory][index]] -= 1;
                                  command.listCommandeSub[mapProductCategory[currentCategory][index].id] -= 1;
                                  command.totalEnEuro -= mapProductCategory[currentCategory][index].prix;
                                  command.listeCommande.removeWhere((key, value) => value == 0);
                                  command.listCommandeSub.removeWhere((key, value) => value == 0);
                                });
                            },
                          )
                        ]
                      ),
                    ),
                  );
                }
              )
            ),
          ),
        ),
      );
    }

    return loading ? LoadingSimple() : Scaffold(
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
                Constants['choose_your_products'],
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 2.0,
                  fontSize: 15.0
                )
              ),
            ),
            Expanded(
              flex: 1,
              child: StreamProvider<List<Command>>.value(
                value: CommandDatabaseService().getCommandStream,
                child: ShoppingCart()
              )
            ),
          ]
        )
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Card(
            child: ListTile(
              onTap: () {},
              title: Text(arguments['partner'], style: TextStyle(color: Constants['primary_color'], fontWeight: FontWeight.bold, fontSize: 18.0),),
              leading: arguments['partnerPic'] == '' ?
              Icon(
                Icons.restaurant,
                color: Colors.amber,
              )
              :
              Expanded(
                child: Container(
                  width: 80.0,
                  child: Image.asset('public/images/${arguments['partnerPic']}')
                ),
              ),
            ),
          ),
          SizedBox(height: 10.0),
          _showListOrNone(),
          _listProducts(),
          // :
          //  _expansionTileBuild('Légumes')
        ]
      ),
      floatingActionButton: Container(
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
        height: 90.0,
        width: 165.0,
        child: FloatingActionButton(
          onPressed: () async { 
            setState(() {
              loading = true;
            });
            dynamic result = await _auth.createCommand(command);
            if(result == null){
              setState(() {
                loading = false;
                print('error creating command');
              });
            }else{
              Navigator.pushReplacementNamed(context, '/your_command', arguments: {'idUser': arguments['idUser']});
            }
           },
          backgroundColor: Constants['primary_color'],
          child: Text('Commander', style: TextStyle(color: Colors.white, fontSize: 12.0))
        )
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}