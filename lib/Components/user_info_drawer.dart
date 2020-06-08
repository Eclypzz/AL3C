import 'package:bringit/Entities/user.dart';
import 'package:bringit/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class UserInfoDraweer extends StatefulWidget {
  @override
  _UserInfoDraweerState createState() => _UserInfoDraweerState();
}

class _UserInfoDraweerState extends State<UserInfoDraweer> {
  @override
  Widget build(BuildContext context) {

    final usersInfo = Provider.of<List<User>>(context);
    final user = Provider.of<User>(context);
    print('user info '+usersInfo.toString());
    print('user info '+user.nom);
    //User currentUser = UserDatabaseService().findUserWithEmailFromStore('id');
    User currentUser = User();

    //User currentUser = UserDatabaseService().findUserWithId(id, usersInfo);
    return DrawerHeader(
      decoration: BoxDecoration(
        color: Constants['primary_color']
      ),
      child: Row(
        children: <Widget>[
        RaisedButton.icon(
        onPressed: () {
          print('user info '+usersInfo.toString());
          print('user info '+user.nom);

        }, 
        icon: Icon(Icons.add), 
        label: Text('Test')
        ),
          CircleAvatar(
          backgroundImage: AssetImage('public/images/onepunch.png'),
          radius: 40.0,
        ),
        SizedBox(width: 20.0,),
        Text(
          currentUser.nom + ' ' + currentUser.prenom,
          style: TextStyle(
            fontSize: 30.0,
            color: Constants['secondary_color'],
            ),
        )
        ]
      )
    );
  }
}