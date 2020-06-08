import 'package:bringit/Entities/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductPartnerDatabaseService {

  //final String uid;

  final String documentID;
  CollectionReference productCollection;

  ProductPartnerDatabaseService({ this.documentID }){
    productCollection = Firestore.instance.collection('partners').document(documentID).collection('products');
    //productCollection = Firestore.instance.collection('products');

  }

  Future updateProductData({String docNum, String category, String nom, double prix, String unite}) async{
    print("begin creating product");
    return await productCollection.document(docNum).setData({
      'id': docNum,
      'category': category,
      'nom': nom,
      'prix': prix,
      'unite': unite ?? ''
    });
  }

  // get Stream
  Stream<List<Product>> get productsFromStream{
    return productCollection.snapshots().map(_listProductsFromSnapshot);
  }

  List<Product> _listProductsFromSnapshot(QuerySnapshot snapshot){
    //print('document id '+documentID);
    try{
      return snapshot.documents.map((doc) {
        return Product(
          id: doc.documentID,
          nom: doc.data['nom'] ?? '',
          prix: doc.data['prix'].toDouble() ?? 0.0,
          category: doc.data['category'] ?? '',
          unite: doc.data['unite'] ?? ''
        );
      }).toList();
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  // get list category
  List<String> getCategories(List<Product> products){
    List<String> categories = [];
    products.map((product) => {
      if(!categories.contains(product.category)){
        categories.add(product.category)
      }
    }).toList();
    return categories;
  }

  // get products from categories
  List<Product> getProductsFromCategory(String category, List<Product> allProducts){
    List<Product> products = [];

    allProducts.map((product) => {
      if(product.category == category && !products.contains(product)){
        products.add(product)
      }
    }).toList();

    return products;
  }
}