
import 'package:bringit/Entities/product.dart';
import 'package:bringit/Utils/constants.dart';

class Command {
  String idDemandeur;
  String idRepondeur;
  String idMagasin;
  //List<Product> listeCommande;
  Map<Product,int> listeCommande;
  Map<String,int> listCommandeSub;
  String status;
  double totalEnEuro;
  double point;
  String id;

  Command({ this.id, this.idDemandeur, this.idRepondeur, this.idMagasin, this.listeCommande, this.listCommandeSub, this.status, this.totalEnEuro, this.point }) {
    this.status = this.status ?? StatusCommand[0];
    this.point = this.point ?? 10.0;
    this.id = this.id ?? DateTime.now().toString();
  }

  void setRepondeur(String idRepondeur){
    this.idRepondeur = idRepondeur;
  }

  void setDemander(String idDemandeur) {
    this.idDemandeur = idDemandeur;
  }

  void setMagasin(String idMagasin){
    this.idMagasin = idMagasin;
  }
  void setStatut(String status){
    this.status = status;
  }
}