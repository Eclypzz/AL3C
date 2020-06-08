import 'package:bringit/Components/Command/list_partenaire.dart';
import 'package:bringit/Entities/partenaire.dart';
import 'package:bringit/Services/partner_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateCommand extends StatefulWidget {
  @override
  _CreateCommandState createState() => _CreateCommandState();
}

class _CreateCommandState extends State<CreateCommand> {
  @override
  Widget build(BuildContext context) {
   
    return StreamProvider<List<Partenaire>>.value(
      value: PartnerDatabaseService().partnersFromStream,
      child: ListPartenaire(),
    );
  }
}