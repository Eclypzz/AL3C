
import 'package:bringit/Entities/partenaire.dart';
import 'package:bringit/Entities/product.dart';
import 'package:bringit/Entities/user.dart';
import 'package:bringit/Utils/constants.dart';

class Command {
  User demandeur;
  User repondeur;
  Partenaire magasin;
  List<Product> listeCommande;
  StatusCommand status;

  Command({this.demandeur, this.magasin, this.listeCommande}) {
    this.status = StatusCommand.EN_ATTENTE;
  }

  void setRepondeur(User repondeur){
    this.repondeur = repondeur;
  }

  void setStatut(StatusCommand status){
    this.status = status;
  }
}