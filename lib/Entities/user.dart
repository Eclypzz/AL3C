import 'package:bringit/Entities/adress.dart';

class User{
  String id;
  String nom;
  String prenom;
  String tel;
  String email;
  Adress adress;
  double personalScores;
  String pic;

  User({ this.id, this.nom, this.prenom, this.tel, this.email, this.adress, this.personalScores, this.pic}){
    this.personalScores = this.personalScores ?? 0.0;
  }

  void setDetails({String nom, String prenom, String tel, Adress adress, double score, String pic}){
    this.nom = nom;
    this.prenom = prenom;
    this.tel = tel;
    this.adress = adress;
    this.personalScores = score;
    this.pic = pic;
  }
}