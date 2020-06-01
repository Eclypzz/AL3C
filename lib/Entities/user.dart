import 'package:bringit/Entities/adress.dart';
import 'package:bringit/Entities/score.dart';

class User{
  String id;
  String nom;
  String prenom;
  String tel;
  String email;
  Adress adress;
  List<Score> personalScores;

  User({ this.id, this.nom, this.prenom, this.tel, this.email, this.adress}){
    this.personalScores = List<Score>();
  }
}