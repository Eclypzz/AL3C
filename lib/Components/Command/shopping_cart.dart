import 'package:bringit/Entities/command.dart';
import 'package:bringit/Services/command_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShoppingCart extends StatefulWidget {
  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  Map arguments;
  List<Command> listCommands;
  int numberOfCommands;
  @override
  void initState() {
    super.initState();
  }

  bool _showNumber(){
    return ( numberOfCommands > 0 );
  }
  @override
  Widget build(BuildContext context) {
    listCommands = Provider.of<List<Command>>(context);
    arguments = ModalRoute.of(context).settings.arguments;
    numberOfCommands = CommandDatabaseService().getUserCommandsFromID(arguments['idUser'], listCommands).length;

    return 
      GestureDetector(
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Icon(
              Icons.shopping_cart,
              size: 36.0,
            ),
            if (_showNumber())
              Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: CircleAvatar(
                  radius: 8.0,
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  child: Text(
                    numberOfCommands.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                    ),
                  ),
                ),
              ),
          ],
        ),
        onTap: () {
          Navigator.pushReplacementNamed(context, '/your_command', 
          arguments: {
            'idUser': arguments['idUser']
          });
        },
     // ),
    );
  }
}