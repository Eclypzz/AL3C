
import 'package:bringit/Entities/partenaire.dart';
import 'package:bringit/Entities/user.dart';

class Score {
  User user;
  Partenaire partenaire;
  int score;

  Score({this.user, this.partenaire, this.score});

  void setScore(int score){
    this.score = score;
  }
}