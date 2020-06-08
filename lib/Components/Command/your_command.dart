import 'package:bringit/Components/Command/list_command.dart';
import 'package:bringit/Entities/command.dart';
import 'package:bringit/Entities/partenaire.dart';
import 'package:bringit/Services/command_database.dart';
import 'package:bringit/Services/partner_database.dart';
import 'package:bringit/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class YourCommand extends StatefulWidget {
  final String idUser;
  YourCommand({ this.idUser });
  @override
  _YourCommandState createState() => _YourCommandState();
}

class _YourCommandState extends State<YourCommand> {
  String idUser;
  Map arguments;
  @override
  Widget build(BuildContext context) {
    arguments = ModalRoute.of(context).settings.arguments;
    idUser = widget.idUser ??  arguments['idUser'];
    
    return MultiProvider(
      providers: [
        StreamProvider<List<Partenaire>>.value(value: PartnerDatabaseService().partnersFromStream),
        StreamProvider<List<Command>>.value(value: CommandDatabaseService().getCommandStream)
      ],
      child: ListCommand(defautlChoice: Constants['your_command'], idUser: idUser),
    );
  }
}