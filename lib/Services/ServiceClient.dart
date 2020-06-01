
import 'package:bringit/Entities/command.dart';
import 'package:bringit/Entities/user.dart';
import 'package:bringit/Utils/constants.dart';

class ServiceClient {

  ServiceClient ();

  void accepterLaCommande(User repondeur, Command command){
    command.setRepondeur(repondeur);
    command.setStatut(StatusCommand.EN_COURS);
  }

  void finishCommand(Command command){
    command.setStatut(StatusCommand.FINI);
  }
  
}