import 'package:bringit/Entities/adress.dart';
import 'package:bringit/Entities/command.dart';
import 'package:bringit/Entities/partenaire.dart';
import 'package:bringit/Entities/product.dart';
import 'package:bringit/Entities/user.dart';
import 'package:bringit/Services/auth.dart';
import 'package:bringit/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommandDetails extends StatefulWidget {

  final List<Command> currentListCommands;
  final String idUser;
  CommandDetails({ this.currentListCommands, this.idUser });
  @override
  _CommandDetailsState createState() => _CommandDetailsState();
}

class _CommandDetailsState extends State<CommandDetails> {
  List<Product> listProducts;
  List<Partenaire> listPartners;
  List<User> listUsers;
  String currentDemandeur;
  Map arguments;
  bool loading;
  String idUser;
  AuthService _auth = AuthService();

   @override
  void initState() {
    super.initState();
    listPartners = [Partenaire(id: '',name: '', idProducts: [''], products: [Product()])];
    loading = false;
  }
  // get current user
  User _getCurrentUser(String idUser, List<User> listUsers){
    User u = User();
    listUsers.map((user) => {
      if(user.id == idUser){
        u = user
      }
    }).toList();

    return u;
  }
  // get product from id
  Product _getProductFromID(String idPro, List<Product> listProducts){
    Product found = Product();
    listProducts.map((product) {
      if(product.id == idPro) {
        found = product;
      }
    }).toList();

    return found;
  }
  // get details command
  String _commandDetail(Command command, List<Product> listProducts){
    String details = '';
    command.listCommandeSub.forEach((key, value) { 
      Product pro = _getProductFromID(key, listProducts);
      details += '${pro.nom} - $value ${pro.unite}\n';
    });
    return details;
  }
  // find partner from id
  Partenaire getPartnerFromId(String idP, List<Partenaire> listPartners){
    Partenaire p = Partenaire();
    listPartners.map((partner) => {
      if(partner.id == idP){
        p = partner
      }
    }).toList();
    
    return p;
  }

  // find user from id
  User getUserFromId(String idU, List<User> listUsers){
    User u = User();
    listUsers.map((user) => {
      if(user.id == idU){
        u = user
      }
    }).toList();

    return u;
  }

  // get couleur pour le status
  Color _statusColor(Command command){
    return command.status == StatusCommand[0] ? Constants['primary_color'] : command.status == StatusCommand[1] ? Color(0xFFFF0000) : Constants['third_color'];
  }


  // show action button
  Widget _actionsButton(Command command){
    return Row(
      children: <Widget>[
        Text(
          '${command.status}',
          style: TextStyle(
            color: _statusColor(command), 
            fontSize: 12.0, fontWeight: FontWeight.bold
          )
        ),
        FlatButton(
          onPressed: () async {
            // cannot accept owned command
            if(command.status == StatusCommand[0] && command.idDemandeur == idUser){
              return null;
            }
            // service provider cannot click finish command 
            else if (command.status == StatusCommand[1] && command.idRepondeur == idUser){
              return null;
            }else{
              // update command status
              String currentStat = command.status;
              dynamic result = await _auth.updateCommandStatus(command, currentStat == StatusCommand[0] ? StatusCommand[1] : StatusCommand[2], idUser);
              if(result != null){
                currentStat == StatusCommand[0] ? command.setStatut(StatusCommand[1]) : command.setStatut(StatusCommand[2]);
                // command finished, add point to user 
                if (currentStat == StatusCommand[1]){
                  User userGetPoint = _getCurrentUser(command.idRepondeur, listUsers);
                  double newPoint = command.point+userGetPoint.personalScores;
                  print('user to update ${userGetPoint.nom}');
                  print('new point ${newPoint.toString()}');
                  dynamic res = await _auth.updateUserPoint(userGetPoint, newPoint);
                  if(res == null){
                    print('Impossible de mise à jour le point');
                  }
                } 
              }else{
                print('Impossible de mise à jour du status de commande');
              }
            }
           },
          child: Text(
            command.status == StatusCommand[0] ? 
            command.idDemandeur == idUser ? '' : Constants['accept_command'] // cannot accept own command
            : command.idRepondeur == idUser ? '' : Constants['finish_command'], // service provider cannot click finish command
            style: TextStyle(
              color: command.status == StatusCommand[0] ? Colors.red : Constants['secondary_color'],
            ),
          ))
      ],
    );
  }
  // adress to string
  String _adressToString(Adress adress){
    return '${adress.num} ${adress.voie} ${adress.codePostal} ${adress.ville}';
  }
  // details du command
  Widget _detailsCommands(Partenaire magasin, User demandeur, Command command){
    return ExpansionTile(
      title: Text(
        '${magasin.name} - ${command.totalEnEuro.toStringAsFixed(2).toString()}€ \n${command.point} point(s)',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          letterSpacing: 2.0
        )
      ),
      children: <Widget>[
        ListTile(
          leading: Column(children: <Widget>[
            Text('Demandeur', style: TextStyle(color: Constants['primary_color'], fontSize: 12.0, fontWeight: FontWeight.bold)),
            Icon(Icons.airline_seat_recline_extra, color: Constants['primary_color'],)
          ],),
          title: Text(
            '${demandeur.nom} ${demandeur.prenom} - ${demandeur.tel} - ${_adressToString(demandeur.adress)}',
            style: TextStyle(color: Constants['primary_color'], fontSize: 12.0, fontWeight: FontWeight.bold)),
        ),
        if(command.idRepondeur != '')
        ListTile(
          leading: Column(children: <Widget>[
            Text('Traité par', style: TextStyle(color: Constants['secondary_color'], fontSize: 12.0, fontWeight: FontWeight.bold)),
            Icon(Icons.record_voice_over, color: Constants['secondary_color'],)
          ],),
          title: Text(
            '${getUserFromId(command.idRepondeur,listUsers).nom} ${getUserFromId(command.idRepondeur,listUsers).prenom} - ${getUserFromId(command.idRepondeur,listUsers).tel}',
            style: TextStyle(color: Constants['secondary_color'], fontSize: 12.0, fontWeight: FontWeight.bold)),
        ),
        ListTile(
          title: Text(
            _commandDetail(command, listProducts),
            style: TextStyle(color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.bold)),
        ),
        ListTile(
          title: _actionsButton(command)
        ),
      ],
    );
  }
  
  // show list or none
  @override
  Widget build(BuildContext context) {

    listUsers = Provider.of<List<User>>(context);
    listPartners = Provider.of<List<Partenaire>>(context);
    listProducts = Provider.of<List<Product>>(context);
    arguments = ModalRoute.of(context).settings.arguments;
    idUser = widget.idUser ?? arguments['idUser'];

    return
        Expanded(
          child: ListView.builder(
            itemCount: widget.currentListCommands.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 3.0),
                child: Card(
                  child: ListTile(
                    onTap: () {},
                    leading: Icon(
                      Icons.shopping_basket,
                      color: Constants['primary_color'],
                    ),
                    title: 
                    _detailsCommands(getPartnerFromId(widget.currentListCommands[index].idMagasin, listPartners), 
                                      getUserFromId(widget.currentListCommands[index].idDemandeur, listUsers), 
                                      widget.currentListCommands[index]),
                    //Text('${getPartnerFromId(widget.currentListCommands[index].idMagasin, listPartners).name}'),
                  ),
                ),
              );
            },
          ),
        );
  }
}