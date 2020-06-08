class Adress{
  String num;
  String voie;
  int codePostal;
  String ville;
  double latitude;
  double longitude;

  Adress({this.num, this.voie, this.ville, this.codePostal, this.latitude, this.longitude});

  String getAdressString(){
    return '${this.num} ${this.voie} ${this.codePostal} ${this.ville}';
  }
}