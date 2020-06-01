import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:bringit/Utils/constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingSimple extends StatefulWidget {
  @override
  _LoadingSimpleState createState() => _LoadingSimpleState();
}

class _LoadingSimpleState extends State<LoadingSimple> {

  @override
  void initState() {
    super.initState();
    getData();    
  }


  Future<void> getData() async {
    // simulate network request for a username
    // await make every other functions wait until it's finished
    Response res = await get('https://jsonplaceholder.typicode.com/todos/1');
    Map data = jsonDecode(res.body);

    print(data);
    print(data['title']);
    // simulated network request to get bio of username
    // other functions will carry on without waiting for this function to finished
    Future.delayed(Duration(seconds: 1), () {
      print("");
    });

    //Navigator.pushReplacementNamed(context, '/list_produtcs');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                Constants['loading'],
                style: TextStyle(
                  color: Colors.grey[200],
                  fontSize: 20.0,
                  letterSpacing: 3.0
                  )
            ),
              SizedBox(width: 10.0),
              SpinKitWanderingCubes(
                //color: Constants['primary_color'],
                color: Colors.grey[200],
                size: 20.0,
              ),
            ],
          )
      ),
      backgroundColor: Constants['primary_color'],
    );
  }
}