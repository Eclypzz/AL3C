import 'dart:async';
import 'package:bringit/Entities/adress.dart';
import 'package:bringit/Entities/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDatabaseService {

  final String uid;
  CollectionReference userCollection;

  UserDatabaseService({ this.uid }){
    userCollection = Firestore.instance.collection('users');
  }

  // user collection reference
  //final CollectionReference userCollection = Firestore.instance.collection('users');
  
  Future updateUserData({String nom, String prenom, String email, String tel, Adress adress}) async{
    return await userCollection.document(uid).setData({
      'nom': nom,
      'prenom': prenom,
      'tel': tel,
      'email': email,
      'adress': {
        'num': adress.num,
        'voie': adress.voie,
        'ville': adress.ville,
        'code_postal': adress.codePostal,
        'latitude': adress.latitude,
        'longitude': adress.longitude
      },
      'score': 0,
    });
  }

  // find user with id
  User findUserWithIdFromList(String id, List<User> users) {
    User user;
    for( User u in users ){
      if (u.id == id){
        user = u;
      }
    }
    return user;
  }
  // get user stream
  Stream<List<User>> get getUserStream{
    return userCollection.snapshots().map(_userListFromSnapshot);
  }

  // user list from snapshot
  List<User> _userListFromSnapshot(QuerySnapshot snapshot) {
    try{
      return snapshot.documents.map((doc) {
        return User(
          id: doc.documentID,
          nom: doc.data['nom'] ?? '',
          prenom: doc.data['prenom'] ?? '',
          email: doc.data['email'] ?? '',
          tel: doc.data['tel'] ?? '',
          adress: Adress(
            num: doc.data['adress']['num'] ?? null,
            voie: doc.data['adress']['voie'] ?? null,
            codePostal: doc.data['adress']['code_postal'].toInt() ?? null,
            ville: doc.data['adress']['ville'] ?? null,
            latitude: doc.data['adress']['latitude'] ?? null,
            longitude: doc.data['adress']['longitude'] ?? null
          ),
          personalScores: doc.data['score'].toDouble() ?? 0.0,
          pic: doc.data['pic'] ?? ''
        );
      }).toList();
    }catch(e) {
      print(e.toString());
      return null;
    }
  }
  // 
  Future getUserInApp(FirebaseUser user) async{
    User userInApp = User(id: user.uid, nom: '', prenom: '', tel: '', adress: null, email: user.email);
    if(user != null){
      DocumentReference documentReference = Firestore.instance.collection("users").document('${user.uid}');
      Adress adress;
      await documentReference.get().then((data) => {
        if (data.exists) {
          adress = Adress(num: data.data['adress']['num'], voie: data.data['adress']['voie'], ville: data.data['adress']['ville'], codePostal: data.data['adress']['vode_postal']),
          userInApp.setDetails(nom: data.data['nom'], prenom: data.data['prenom'], tel: data.data['tel'], adress: adress, score: data.data['score']),
        }
        else{
          print("No such user")
        }
      });
    }
    return userInApp;
  }
  // update user point
  Future updateUserPoint(double point) async{
    return await userCollection.document(uid).updateData({
      'score': point
    });
  }
  Future updateUserLatLong(double lat, double long) async{
    return await userCollection.document(uid).updateData({
      'adress': {
        'latitude': lat,
        'longitude': long
      }
    });
  }
}