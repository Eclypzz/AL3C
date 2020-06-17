import 'package:bringit/Entities/adress.dart';
import 'package:bringit/Entities/command.dart';
import 'package:bringit/Entities/partenaire.dart';
import 'package:bringit/Services/command_database.dart';
import 'package:bringit/Services/partner_database.dart';
import 'package:bringit/Services/product_database.dart';
import 'package:bringit/Services/product_partner_database.dart';
import 'package:bringit/Services/user_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bringit/Entities/user.dart';

import '../Entities/adress.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // create user object
  User _userFireBase(FirebaseUser user){

    return (user != null) ? User(id: user.uid, email: user.email, nom: 'nom', prenom: 'prenom', tel: 'tel', adress: null, personalScores: 0, pic: '') : null;
  }
  
  // on auth change
  Stream<User> get user{
    return _auth.onAuthStateChanged
    //.map((FirebaseUser user) => _userFireBase(user, ));
    .map(_userFireBase);
  }

  // sign in with email and password
  Future signInWithEmailandPassword(String email, String password) async {
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;

      
      // get user data from firebase
      if(user != null){
        //userCreate = User(id: user.uid, nom: userCreate.nom, prenom: userCreate.prenom, tel: userCreate.tel, adress: null, email: user.email);
        return User(id: user.uid, nom: '', prenom: '', tel: '', adress: null, email: user.email, personalScores: 0, pic: '');
      }

      //return userCreate;
    }catch(e) {
      print(e.toString());
      return null;
    }
  }
  // register
  Future registerWithEmailandPassword(String email, String password, String nom, String prenom, String tel, Adress adress) async {
    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;

      User userCreated = User(nom: nom, prenom: prenom, adress: adress, tel: tel, email: email, id: user.uid);
      await createUserDB(userCreated);

      return userCreated;
    }catch(e) {
      print('error: '+e.toString());
      return null;
    }
  }

  //Future createUserDB(List<User> users) async{
  Future createUserDB(User user) async{
    try{
      //users.map((user) async => {
      await UserDatabaseService(uid: user.id).updateUserData(nom: user.nom, prenom: user.prenom, email: user.email , tel: user.tel, adress: user.adress);
      print('create user ${user.nom} ${user.prenom}');
      //}).toList();
      return 1;
    }catch(e) {
      print(e.toString());
      return null;
    }
  }

  // update user point
  Future updateUserPoint(User user, double point) async {
    try{
      await UserDatabaseService(uid: user.id).updateUserPoint(point);
      return 1;
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  Future updateUserLatLong(User user, double lat, double long) async {
    try{
      await UserDatabaseService(uid: user.id).updateUserLatLong(lat,long);
      return 1;
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  //create product
  Future createProductForPartner(String docNum, String idPartner, String category, String nom, double prix, String unite) async{
    try{
      await ProductPartnerDatabaseService(documentID: idPartner).updateProductData(docNum: docNum, category: category, nom: nom, prix: prix, unite: unite);    
      return 1;
    }catch(e) {
      print(e.toString());
      return null;
    }
  }
   //create product
  Future createProducts(String docNum, String category, String nom, double prix, String unite) async{
    try{
      await ProductDatabaseService(documentID: docNum).updateProductData(docNum: docNum, category: category, nom: nom, prix: prix, unite: unite);    
      return 1;
    }catch(e) {
      print(e.toString());
      return null;
    }
  }


  // sign out
  Future signOut() async {
    try{
      return await _auth.signOut();
    }catch(e) {
      print(e.toString());
      return null;
    }
  }

  // create command
  Future createCommand(Command command) async {
    try{
      //String uid = command.idDemandeur+'|'+command.idMagasin;
      await CommandDatabaseService(uid: command.id).updateCommandData(command);
      return 1;
    }catch(e) {
      print(e.toString());
      return null;
    }
  }

  // update command
  Future updateCommandStatus(Command command, String status, String idRepondeur) async {
    try{
      await CommandDatabaseService(uid: command.id).udpateCommandStatus(status, idRepondeur);
      return 1;
    }catch(e) {
      print(e.toString());
      return null;
    }
  }

  // update partner adress
  Future updatePartnerAdress(Partenaire partner, Adress adress) async {
    try{
      await PartnerDatabaseService(uid: partner.id).updatePartnerAdress(adress);
      return 1;
    }catch(e) {
      print(e.toString());
      return null;
    }
  }
}