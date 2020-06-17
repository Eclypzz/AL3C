import 'package:bringit/Entities/adress.dart';
import 'package:bringit/Entities/partenaire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PartnerDatabaseService {

  final String uid;
  CollectionReference partnerCollection;

  PartnerDatabaseService({ this.uid }){
    partnerCollection = Firestore.instance.collection('partners');
  }

  // partners collection reference
  //inal CollectionReference partnerCollection = Firestore.instance.collection('partners');
  // update partner
  Future updatePartnerAdress(Adress adress) async{
    return await partnerCollection.document(uid).updateData({
      'adress': {
        'num': adress.num,
        'voie': adress.voie,
        'code_postal': adress.codePostal,
        'ville': adress.ville,
        'latitude': adress.latitude,
        'longitude': adress.longitude
      }
    });
  }
  // get stream
  Stream<List<Partenaire>> get partnersFromStream{
    return partnerCollection.snapshots().map(_partnersListFromSnapshot);
  }

  // get list<partners>
  List<Partenaire> _partnersListFromSnapshot(QuerySnapshot snapshot){
    try{
      return snapshot.documents.map((doc) {
      return Partenaire(
        id: doc.documentID,
        name: doc.data['name'],
        //products: ProductDatabaseService(doc.documentID).productsFromStream,
        products: null,
        idProducts: doc.data['idProducts'] != null ? doc.data['idProducts'].split(';') : [],
        pic: doc.data['pic'] ?? '',
        url: doc.data['url'] ?? '',
        adress: Adress(
            num: doc.data['adress']['num'] ?? null,
            voie: doc.data['adress']['voie'] ?? null,
            codePostal: doc.data['adress']['code_postal'].toInt() ?? null,
            ville: doc.data['adress']['ville'] ?? null,
            latitude: doc.data['adress']['latitude'] ?? null,
            longitude: doc.data['adress']['longitude'] ?? null
          ),
      );
    }).toList();
    }catch(e) {
      print(e.toString());
      return null;
    }
  }

  Partenaire getPartnerFromID(String idPartner, List<Partenaire> listPartners){
    for(Partenaire p in listPartners){
      if (p.id == idPartner){
        return p;
      }
    }
    return null;
  }
}