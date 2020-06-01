import 'package:bringit/Components/loading_simple.dart';
import 'package:bringit/Entities/adress.dart';
import 'package:bringit/Entities/user.dart';
import 'package:bringit/Services/auth.dart';
import 'package:bringit/Services/user_database.dart';
import 'package:flutter/material.dart';
import 'package:bringit/Utils/constants.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<User> users = [
    User(id: '1zeinwkoHLV1VUGeQrGn4okkRw42', prenom:'Maxime', nom: 'BERTROU-RIVOT', email: 'maxime.bertrou-rivot@bringit.fr', tel: '0005550005', adress: Adress(num: '111', voie: 'holy', codePostal: 31000, ville: 'Toulouse')),
    User(id: 'zYOvGn7qfpVUOgR5UuymfVuqpoo2', prenom:'Duc Trong', nom: 'VO', email: 'duc-trong.vo@bringit.fr', tel: '0005550005', adress: Adress(num: '111', voie: 'holy', codePostal: 31000, ville: 'Toulouse')),
    User(id: '7EELRlt2xsZwtRXa6pcE0w8PKuQ2', prenom:'Carlos', nom: 'FONG-LOPEZ', email: 'calors.fong-lopez@bringit.fr', tel: '0005550005', adress: Adress(num: '111', voie: 'holy', codePostal: 31000, ville: 'Toulouse')),
    User(id: 'DqsyN6bZVxf0xURMFv6G2IIzxYm1', prenom:'Jeremy', nom: 'CANTON', email: 'jeremy.canton@bringit.fr', tel: '0005550005', adress: Adress(num: '111', voie: 'holy', codePostal: 31000, ville: 'Toulouse')),
    User(id: 'pCCNGUtD31TNPzcfJJTdWglbAfx2', prenom:'Samir', nom: 'BOUAHRIRA', email: 'samir.bouahrira@bringit.fr', tel: '0005550005', adress: Adress(num: '111', voie: 'holy', codePostal: 31000, ville: 'Toulouse')),
    //User(id: '', prenom:'Roman', nom: 'MICHONSKA', email: 'roman.michonska@bringit.fr', adress: Adress(num: '111', voie: 'holy', codePostal: 31000, ville: 'Toulouse')),
  ];

  bool loading = false;
  int number = 0;
  final AuthService _auth = AuthService();
  
  @override
  Widget build(BuildContext context) {
    return loading ? LoadingSimple() : Scaffold(
    //image: Image.asset('public/images/bringit_logo.png'),
    appBar: PreferredSize(
      preferredSize: Size.fromHeight(60.0),
      child: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Text(""),
            ),
            Expanded(
              flex: 2,
              child: Container(
                //margin: EdgeInsets.all(20.0),
                padding: EdgeInsets.fromLTRB(10.0, 10.0, 60.0, 0.0),
                child: Image.asset('public/images/bringit_logo.png'),
                //alignment: Alignment.centerLeft,
              ),
            ),
            //Expanded( 
              // flex: 1,
              // child: Container(
              //   child: Text(""),
              //   // IconButton(
              //   //   icon: Icon(Icons.search), 
              //   //   onPressed: () {
              //   //     print(Constants['search']);
              //   //     Navigator.pushNamed(context, '/');
              //   //   }
              //   // ),
              //   alignment: Alignment.centerRight,
              // ),
              //),
            ],
          ),
        centerTitle: true,
        backgroundColor: Colors.greenAccent[400],
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
            onPressed: () async {
              await _auth.signOut();
            }, 
            icon: Icon(Icons.person), 
            label: Text('Log out'),
          )
        ],
      ),
    ),
    body: Padding(
      padding: EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            "Number is",
            style: TextStyle(
              color: Colors.amberAccent,
              letterSpacing: 2.0,
              height: 10.0,
            )
          ),
          SizedBox(width: 10.0,),
          Text(
            "$number",
            style: TextStyle(
              color: Colors.black,
              height: 10.0,
            )
            //child: Image.asset('public/images/bringit_logo.png')
          ),
          SizedBox(width: 10.0),  
          Text(
            "$number",
            style: TextStyle(
              color: Colors.black,
              height: 10.0,
            )
            //child: Image.asset('public/images/bringit_logo.png')
          ),
          SizedBox(width: 20.0),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                //number += 1;
                //create new user documents in db
                users.map((user) async => {
                  loading = true,
                  await UserDatabaseService(uid: user.id).updateUserData(nom: user.nom, prenom: user.prenom, tel: user.tel, adress: user.adress),
                  print('create user ${user.nom} ${user.prenom}'),
                  loading = false,
                });
              });
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.green[600],
      ),
        ],
      ),
  ),
  
  );
  }
}