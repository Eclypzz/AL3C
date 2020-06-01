import 'package:bringit/Entities/adress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDatabaseService {

  final String uid;

  UserDatabaseService({ this.uid });

  // user collection reference
  final CollectionReference userCollection = Firestore.instance.collection('users');

  Future updateUserData({String nom, String prenom, String tel, Adress adress}) async{
    return await userCollection.document(uid).setData({
      'nom': nom,
      'prenom': prenom,
      'tel': tel,
      'adress': adress
    });
  }

}