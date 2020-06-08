import 'package:bringit/Entities/user.dart';
import 'package:bringit/Services/user_database.dart';
import 'package:bringit/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class SideMenu extends StatefulWidget {
  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  User found;
  
  @override
  Widget build(BuildContext context) {

  // User info
  final usersInfo = Provider.of<List<User>>(context);
  final user = Provider.of<User>(context);

  found = UserDatabaseService().findUserWithIdFromList(user.id, usersInfo);
  user.setDetails(nom: found.nom, prenom: found.prenom, adress: found.adress, tel: found.tel, score: found.personalScores);

    // drawer user info line
  Widget _userInfoLine(String title, String content, Icon icon){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(height: 5.0),
        Card(
          child: ListTile(
            leading: icon,
            subtitle: Text(
              title,
              style: TextStyle(color: Constants['third_color'], fontSize: 12.0),
              textAlign: TextAlign.left,
            ),
            title: Text(
              content,
              style: TextStyle(color: Constants['primary_color'], fontSize: 14.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
          )
        )
      ],
    );
  }

  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        Container(
          height: 150.0,
          child: DrawerHeader(
            decoration: BoxDecoration(
              color: Constants['primary_color'],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                backgroundImage: AssetImage('public/images/onepunch.png'),
                radius: 30.0,
                ),
                SizedBox(width: 20.0,),
                Column(
                  children: <Widget>[
                    Divider(height: 15.0),
                    Text(
                      user.nom,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Constants['secondary_color'],
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      user.prenom.toUpperCase(),
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Constants['secondary_color'],
                      ),
                    ),
                  ]
                ),
                SizedBox(width: 20.0),
              ]
            )
          ),
        ),
        
        Container(
          alignment: Alignment.center,
          width: 50,
          height: 50,
          child: Text(user.personalScores.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 17.0)),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Constants['secondary_color'],
          )
        ),
        _userInfoLine('ID', user.id, Icon(Icons.info)),
        _userInfoLine('EMAIL', user.email, Icon(Icons.email)),
        _userInfoLine('TELEPHONE', user.tel, Icon(Icons.phone_iphone)),
        _userInfoLine('ADRESSE', '${user.adress.num} ${user.adress.voie} - ${user.adress.codePostal} ${user.adress.ville}', Icon(Icons.home)),
        Card(
          child: FlatButton(
            onPressed: () { 
              Navigator.pushNamed(context, '/create_command', arguments: {'idUser': user.id});
              },
            child: ListTile(
              title: Text(
                'FAIRE UNE DEMANDE',
                style: TextStyle(color: Constants['primary_color'], fontSize: 12.0),
                textAlign: TextAlign.left,
              ),
              trailing: Icon(Icons.shopping_cart)
            ),
          ),
        ),
        Card(
          child: FlatButton(
            onPressed: () { 
              Navigator.pushNamed(context, '/your_command', arguments: {'idUser': user.id});
              },
            child: ListTile(
              title: Text(
                'VOTRE DEMANDE',
                style: TextStyle(color: Constants['primary_color'], fontSize: 12.0),
                textAlign: TextAlign.left,
              ),
              trailing: Icon(Icons.description)
            ),
          ),
        )
      ],
    ),
  );
  }
}