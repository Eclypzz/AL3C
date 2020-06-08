import 'package:bringit/Components/loading_simple.dart';
import 'package:bringit/Entities/adress.dart';
import 'package:bringit/Services/auth.dart';
import 'package:bringit/Utils/constants.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {

  final Function toggleView;

  Register({ this.toggleView });
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  //attribut
  String nom = '';
  String prenom = '';
  String email = '';
  String password = '';
  String repassword = '';
  String numStreet;
  String street;
  String postalCode;
  String city;
  String tel;
  String error = '';

  Widget _entryField(String title, String field, Function validator, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Constants['primary_color']),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
              obscureText: isPassword,
              onChanged: (val) {
                  setState(() => field = val);
              },
              validator: (val) => validator(val),
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }

  String emailValidator(String val){
    return (val.isEmpty ) ? 'Input valid email' : null;
  }
  Widget _fieldsWidget() {
    return Column(
      children: <Widget>[
        _entryField("Votre Nom", nom, emailValidator),
        _entryField("Votre Prénom", prenom, emailValidator),
        _entryField("Votre Email", email, emailValidator),
        _entryField("Votre mot de pass", password, emailValidator, isPassword: true),
        _entryField("Resaisie votre mot de passe", repassword, emailValidator, isPassword: true),
        _entryField("Votre numéro de téléphone", tel, emailValidator),
        _entryField("Numéro de voie", numStreet, emailValidator),
        _entryField("Nom de voie", street, emailValidator),
        _entryField("Code Postal", postalCode, emailValidator),
        _entryField("Ville", city, emailValidator)
      ],
    );
  }

  // 
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  
  @override
  Widget build(BuildContext context) {
    return loading ? LoadingSimple() : Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Constants['primary_color'],
        elevation: 0.0,
        title: Text(
          'SING UP WITH BRING IT',
        ),
        actions: <Widget>[
          FlatButton.icon(
            onPressed: () {
              widget.toggleView();
            }, 
            icon: Icon(
              Icons.person, 
              color: Colors.white,
            ), 
            label: Text(
              "LOG IN",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.0
              )
            ),
            )
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 20.0),
                _fieldsWidget(),
                SizedBox(height: 20.0),
                RaisedButton(
                  color: Constants['primary_color'],
                  onPressed: () async {
                    if(_formKey.currentState.validate()){
                      setState(() {
                        loading = true;
                      });
                      dynamic result = await _auth.registerWithEmailandPassword(email, password, nom, prenom, tel, 
                                                  Adress(num: numStreet, voie: street, ville: city, codePostal: int.parse(postalCode)));
                      if(result == null){
                        setState(() {
                          error = 'veify your input';
                          loading = false;
                        });
                      }
                    }
                  },
                  child: Text(
                    "Enregistrer",
                    style: TextStyle(
                      color: Colors.white,
                    )
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  error,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14.0
                  )
                )
              ],
            )
          )
        ),
      ),
    );
  }
}