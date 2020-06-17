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
  final List<Command> defautCommand;
  ListCommand({ this.defautlChoice, this.idUser, this.defautCommand });
  @override
  _ListCommandState createState() => _ListCommandState();
}


class _ListCommandState extends State<ListCommand> {
  List<Command> listCommands;
  List<Command> listUserCommands;
  List<Partenaire> listPartners;
  //List<Command> currentListCommands;
  List<Command> unfinishedListCommands;
  List<Command> listShopCommands;
  Map<String,String> listPartnersNamesIDs = Map();
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
  
  // stream
  listPartners = Provider.of<List<Partenaire>>(context);
  listCommands = Provider.of<List<Command>>(context);
  arguments = ModalRoute.of(context).settings.arguments;
  // local
  List<String> listPartnersNames = listPartners.map((partner) => partner.name).toList();
  //Map<String,String> listPartnersNamesIDs = Map();
  listPartners.map((partner) => listPartnersNamesIDs[partner.name] = partner.id).toList();
  idUser = widget.idUser ?? arguments['idUser'];
  listUserCommands = CommandDatabaseService().getUserCommandsFromID(idUser, listCommands);
  unfinishedListCommands = CommandDatabaseService().getUnfinishedCommands(listCommands);
  // get command of magasin
  List<Command> _getShopCommands(String idShop, List<Command> allCommands){
    List<Command> shopCommands = [];
    for(Command command in allCommands){
      if(command.idMagasin == idShop){
        shopCommands.add(command);
      }
    }
    return shopCommands;
  }
  //listShopCommands = _getShopCommands(listPartnersNamesIDs[widget.defautlChoice], listCommands);
  // show list or none
  Widget _showHeader(){
    return widget.defautCommand != null ?
      Padding(
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 3.0),
        child: Card(
          child: ListTile(
            onTap: () {},
            title: Text("Vous avvez l'intérêt avec la commande", style: TextStyle(color: Constants['primary_color'], fontWeight: FontWeight.bold)),
            leading: Icon(
              Icons.sentiment_very_satisfied,
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
            if (listPartnersNames.contains(value)) {
              listShopCommands = _getShopCommands(listPartnersNamesIDs[value], unfinishedListCommands);
            }
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
            child: widget.defautCommand != null ?
              CommandDetails(currentListCommands: widget.defautCommand, idUser: idUser)
              :
            currentDemandeur ==  Constants['your_command'] ?
              CommandDetails(currentListCommands: listUserCommands, idUser: idUser)
              :
            // currentDemandeur ==  Constants['all_commands'] ?
            //   CommandDetails(currentListCommands: unfinishedListCommands, idUser: idUser)
            listPartnersNames.contains(currentDemandeur) ?
              CommandDetails(currentListCommands: listShopCommands, idUser: idUser)
              :
              CommandDetails(currentListCommands: unfinishedListCommands, idUser: idUser)
            )
        ]
      ),
    );
  }
}