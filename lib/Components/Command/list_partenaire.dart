import 'package:bringit/Components/loading_simple.dart';
import 'package:bringit/Entities/partenaire.dart';
import 'package:bringit/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListPartenaire extends StatefulWidget {
  @override
  _ListPartenaireState createState() => _ListPartenaireState();
}

class _ListPartenaireState extends State<ListPartenaire> {
  bool loading = false;
  List<Partenaire> listePartenaires;
  Map arguments;

  @override
  void initState() {
    super.initState();
    listePartenaires = [];
  }
  @override
  Widget build(BuildContext context) {

    listePartenaires = Provider.of<List<Partenaire>>(context);
    arguments = ModalRoute.of(context).settings.arguments;
    
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
                Constants['choose_your_shop'],
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
          SizedBox(height: 10.0),
          Expanded(
            child: ListView.builder(
              itemCount: listePartenaires.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 3.0),
                  child: Card(
                    child: ListTile(
                      onTap: () {
                        Navigator.pushNamed(context, '/chose_product', arguments: {
                                                                        'idPartner': listePartenaires[index].id.toString(),
                                                                        'partnerPic': listePartenaires[index].pic,
                                                                        'partner': listePartenaires[index].name,
                                                                        'idUser': arguments['idUser']
                                                                        });
                      },
                      title: Text(listePartenaires[index].name, style: TextStyle(color: Constants['primary_color'], fontWeight: FontWeight.bold, fontSize: 16.0),),
                      leading: Expanded(
                        flex: 3,
                        child: Container(
                          width: 80.0,
                          child: listePartenaires[index].pic == '' ?
                            Icon(
                              Icons.shopping_basket,
                              color: Constants['primary_color'],
                            )
                          :
                            Image.asset('public/images/${listePartenaires[index].pic}')
                          ),
                      )
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