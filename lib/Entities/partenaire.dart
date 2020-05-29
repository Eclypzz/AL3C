import 'package:bringit/Entities/product.dart';

class Partenaire {
  static int idPartenaire = 0;
  int id;
  String name;
  List<Product> products;

  Partenaire({ this.name, this.products }){
    Partenaire.idPartenaire += 1;
    this.id = Partenaire.idPartenaire;
  }
}