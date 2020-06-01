import 'package:bringit/Entities/adress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductDatabaseService {

  final String uid;

  static String partnerUid;
  ProductDatabaseService({ this.uid }){
    partnerUid = this.uid;
  }

  // product collection reference
  final CollectionReference productCollection = Firestore.instance.collection('partners/$partnerUid/products');

  Future updateUserData(String nom, String prenom, String tel, Adress adress) async{
    
  }

}