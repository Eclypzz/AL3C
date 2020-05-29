class Product {
  static int idProduct = 0;
  int id;
  String name;
  double price;

  Product({ this.name, this.price }){
    Product.idProduct += 1;
    this.id = Product.idProduct;
  }
}