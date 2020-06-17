import 'package:bringit/Entities/adress.dart';
import 'package:bringit/Entities/product.dart';

class Partenaire {
  String id;
  String name;
  List<Product> products;
  List<String> idProducts;
  String pic;
  Adress adress;
  String url;

  Partenaire({ this.id, this.name, this.products , this.idProducts, this.adress, this.pic, this.url});

  void setProducts(List<Product> products){
    this.products = products;
  }
}