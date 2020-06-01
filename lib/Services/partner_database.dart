import 'package:bringit/Entities/adress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PartnerDatabaseService {

  final String uid;

  PartnerDatabaseService({ this.uid });

  // partners collection reference
  final CollectionReference partnerCollection = Firestore.instance.collection('partners');

  Future updateUserData(String nom, String prenom, String tel, Adress adress) async{
    //return await partnerCollection.document(uid);
  }

}