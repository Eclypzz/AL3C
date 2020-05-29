import 'package:bringit/Entities/adress.dart';

class User{
  static int idUser = 0;
  int id;
  String nom;
  String prenom;
  String tel;
  String email;
  Adress adress;
  int personalScore;

  User({ this.nom, this.prenom, this.tel, this.email, this.adress}){
    User.idUser += 1;
    this.id = User.idUser;
    this.personalScore = 0;
  }
}