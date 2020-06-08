import 'package:bringit/Components/Command/command_details.dart';
import 'package:bringit/Components/loading_simple.dart';
import 'package:bringit/Entities/command.dart';
import 'package:bringit/Entities/partenaire.dart';
import 'package:bringit/Entities/product.dart';
import 'package:bringit/Entities/user.dart';
import 'package:bringit/Services/command_database.dart';
import 'package:bringit/Services/partner_database.dart';
import 'package:bringit/Services/product_database.dart';
import 'package:bringit/Services/user_database.dart';
import 'package:bringit/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListCommand extends StatefulWidget {
  final String idUser;
  final String defautlChoice;

  ListCommand({ this.defautlChoice, this.idUser });
  @override
  _ListCommandState createState() => _ListCommandState();
}


class _ListCommandState extends State<ListCommand> {
  List<Command> listCommands;
  List<Command> listUserCommands;
  List<Partenaire> listPartners;
  //List<Command> currentListCommands;
  List<Command> unfinishedListCommands;
  String currentDemandeur;
  String idUser;
  Map arguments;
  bool loading;

  @override
  void initState() {
    super.initState();
    listCommands = [Command()];
    listUserCommands = [Command()];
    listPartners = [Partenaire(id: '',name: '', idProducts: [''], products: [Product()])];
    currentDemandeur = widget.defautlChoice;
    loading = false;
  }

  @override
  Widget build(BuildContext context) {
  
  listCommands = Provider.of<List<Command>>(context);
  listPartners = Provider.of<List<Partenaire>>(context);
  arguments = ModalRoute.of(context).settings.arguments;
  List<String> listPartnersNames = listPartners.map((partner) => partner.name).toList();
  idUser = widget.idUser ?? arguments['idUser'];
  listUserCommands = CommandDatabaseService().getUserCommandsFromID(idUser, listCommands);
  unfinishedListCommands = CommandDatabaseService().getUnfinishedCommands(listCommands);

  // show list or none
  Widget _showHeader(){
    return unfinishedListCommands.length == 0 ?
      Padding(
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 3.0),
        child: Card(
          child: ListTile(
            onTap: () {},
            title: Text("Aucun commande encours"),
            leading: Icon(
              Icons.sentiment_dissatisfied,
              color: Constants['primary_color'],
            ),
          ),
        ),
      )
      :
      DropdownButton<String>(
        value: currentDemandeur,
        items: (<String>[Constants['your_command'], Constants['all_commands']]+listPartnersNames).map<DropdownMenuItem<String>>(( String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, textAlign: TextAlign.center,),
          );
        }).toList(),
        onChanged: (String value) {
          setState(() {
            currentDemandeur = value;
          });
        }
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
                'Menu des commandes',
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
          _showHeader(),
          MultiProvider(
            providers: [
              StreamProvider<List<Product>>.value(value: ProductDatabaseService().productsFromStream),
              StreamProvider<List<User>>.value(value: UserDatabaseService().getUserStream),
              StreamProvider<List<Partenaire>>.value(value: PartnerDatabaseService().partnersFromStream)
            ],
            child:currentDemandeur ==  Constants['your_command'] ?
              CommandDetails(currentListCommands: listUserCommands, idUser: idUser)
              :
              CommandDetails(currentListCommands: unfinishedListCommands, idUser: idUser),
            )
        ]
      ),
    );
  }
}