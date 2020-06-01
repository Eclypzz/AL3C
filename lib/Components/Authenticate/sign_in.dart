import 'package:bringit/Components/loading_simple.dart';
import 'package:bringit/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:bringit/Services/auth.dart';
import 'package:google_fonts/google_fonts.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;

  SignIn({ this.toggleView });
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  //attribut
  String email = '';
  String password = '';

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'Bring it',
          style: GoogleFonts.portLligatSans(
            //textStyle: Theme.of(context).textTheme.display1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xFF43B61F),
          )),
    );
  }

  Widget _entryField(String title, {bool isPassword = false}) {
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
                  setState(() => isPassword ? password = val : email = val);
              },
              validator: (val) => null,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Votre Email"),
        _entryField("Votre mot de pass", isPassword: true),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return loading ? LoadingSimple() : Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Constants['primary_color'],
        elevation: 0.0,
        title: Text(
          'SIGN IN TO BRING IT',
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
              "Register",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.0
              )
            ),
            )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 20.0),
                _title(),
                Divider(height: 50.0),
                _emailPasswordWidget(),
                SizedBox(height: 20.0),
                RaisedButton(
                  color: Constants['primary_color'],
                  onPressed: () async {
                    if (_formKey.currentState.validate()){
                      setState(() {
                        loading = true;
                      });
                      dynamic result = await _auth.signInWithEmailandPassword(email, password);
                      if(result == null){
                        setState(() {
                          error = 'Could not sign in with credentials!';
                          loading = false;
                        });
                      }
                    }
                  },
                  child: Text(
                    "Sign in",
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