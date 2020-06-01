import 'package:bringit/Entities/adress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommandDatabaseService {

  final String uid;

  CommandDatabaseService({ this.uid });

  // command collection reference
  final CollectionReference commandCollection = Firestore.instance.collection('commands');

  Future updateUserData(String nom, String prenom, String tel, Adress adress) async{
    //return await commandCollection.document(uid);
  }

}