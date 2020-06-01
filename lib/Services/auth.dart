import 'package:bringit/Entities/adress.dart';
import 'package:bringit/Services/user_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bringit/Entities/user.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // create user object
  User _userFireBase(FirebaseUser user){
    return (user != null) ? User(id: user.uid, email: user.email, nom: '', prenom: '', tel: '') : null;
  }

  // on auth change
  Stream<User> get user{
    return _auth.onAuthStateChanged
    //.map((FirebaseUser user) => _userFireBase(user));
    .map(_userFireBase);
  }

  Future signInAnon() async {
    try{
      AuthResult authResult = await _auth.signInAnonymously();
      FirebaseUser user = authResult.user;
      return _userFireBase(user);
    }catch(e) {
      print(e.toString());
      return null;
    }
  }
  // sign in with email and password
  Future signInWithEmailandPassword(String email, String password) async {
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;

      //create new user documents in db
      // Adress adress = Adress(num: '', voie: '', ville: '', codePostal: 31000);
      // await UserDatabaseService(uid: user.uid).updateUserData(nom: '', prenom: '', tel: '', adress: adress);

      return _userFireBase(user);
    }catch(e) {
      print(e.toString());
      return null;
    }
  }
  // register
  Future registerWithEmailandPassword(String email, String password) async {
    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return _userFireBase(user);
    }catch(e) {
      print(e.toString());
      return null;
    }
  }
  // sign out
  Future signOut() async {
    try{
      return await _auth.signOut();
    }catch(e) {
      print(e.toString());
      return null;
    }
  }
}