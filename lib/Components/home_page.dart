import 'package:flutter/material.dart';
import 'package:bringit/Utils/constants.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  
  int number = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    //image: Image.asset('public/images/bringit_logo.png'),
    appBar: PreferredSize(
      preferredSize: Size.fromHeight(60.0),
      child: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Text(""),
            ),
            Expanded(
              flex: 1,
              child: Image.asset('public/images/bringit_logo.png')
            ),
            Expanded( 
              flex: 2,
              child: Container(
                child: IconButton(
                  icon: Icon(Icons.search), 
                  onPressed: () {
                    print(Constants['search']);
                    Navigator.pushNamed(context, '/');
                  }
                ),
                alignment: Alignment.centerRight,
              ),
              ),
            ],
          ),
        centerTitle: true,
        backgroundColor: Colors.greenAccent[400],
        elevation: 0.0,
      ),
    ),
    body: Padding(
      padding: EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            "Number is",
            style: TextStyle(
              color: Colors.amberAccent,
              letterSpacing: 2.0,
              height: 10.0,
            )
          ),
          SizedBox(width: 10.0,),
          Text(
            "$number",
            style: TextStyle(
              color: Colors.black,
              height: 10.0,
            )
            //child: Image.asset('public/images/bringit_logo.png')
          ),
          SizedBox(width: 10.0),  
          Text(
            "$number",
            style: TextStyle(
              color: Colors.black,
              height: 10.0,
            )
            //child: Image.asset('public/images/bringit_logo.png')
          ),
          SizedBox(width: 20.0),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                number += 1;
              });
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.green[600],
      ),
        ],
      ),
  ),
  
  );
  }
}