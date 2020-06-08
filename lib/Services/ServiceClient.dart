
import 'package:bringit/Entities/command.dart';
import 'package:bringit/Utils/constants.dart';

class ServiceClient {

  ServiceClient ();

  void accepterLaCommande(String idRepondeur, Command command){
    command.setRepondeur(idRepondeur);
    command.setStatut(StatusCommand[1]);
  }

  void finishCommand(Command command){
    command.setStatut(StatusCommand[2]);
  }
  
}