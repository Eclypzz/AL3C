import 'package:bringit/Entities/command.dart';
import 'package:bringit/Utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommandDatabaseService {

  final String uid;
  CollectionReference commandCollection;

  CommandDatabaseService({ this.uid }){
    commandCollection = Firestore.instance.collection('commands');
  }

  // command collection reference
  //final CollectionReference commandCollection = Firestore.instance.collection('commands');

  Future updateCommandData(Command command) async{
    return await commandCollection.document(uid).setData({
      'idDemandeur': command.idDemandeur,
      'idMagasin': command.idMagasin,
      'idRepondeur': command.idRepondeur ?? '',
      'status': command.status,
      'totalEnEuro': command.totalEnEuro,
      'point': command.point,
      'details': command.listCommandeSub
      });
  }

  Future udpateCommandStatus(String status, String idRepondeur) async {
    return await commandCollection.document(uid).updateData({
      'idRepondeur': idRepondeur ?? '',
      'status': status
    });
  }
  // get all command from an user ID
  List<Command> getUserCommandsFromID(String userID, List<Command> allCommands){
    List<Command> userCommands = [];
    allCommands.map((command) => {
      if(command.idDemandeur == userID && command.status != StatusCommand[2]){
        userCommands.add(command)
      }
    }).toList();

    return userCommands;
  }

  // get command unfinished
  List<Command> getUnfinishedCommands(List<Command> allCommands){
    List<Command> unfinishedCommands = [];
    allCommands.map((command) => {
      if(command.status != StatusCommand[2]){
        unfinishedCommands.add(command)
      }
    }).toList();

    return unfinishedCommands;
  }
  // get command stream
  Stream<List<Command>> get getCommandStream{
    return commandCollection.snapshots().map(_commandListFromSnapshot);
  }

  // user list from snapshot
  List<Command> _commandListFromSnapshot(QuerySnapshot snapshot) {
    try{
      return snapshot.documents.map((doc) {
        return Command(
          id: doc.documentID,
          idDemandeur: doc.data['idDemandeur'],
          idMagasin: doc.data['idMagasin'],
          idRepondeur: doc.data['idRepondeur'] ?? '',
          status: doc.data['status'],
          listeCommande: Map(),
          totalEnEuro: doc.data['totalEnEuro'].toDouble(),
          point: doc.data['point'].toDouble(),
          listCommandeSub: Map<String,int>.from(doc.data['details'])
        );
    }).toList();
    }catch(e){
      print(e.toString());
      return null;
    }
  }
}