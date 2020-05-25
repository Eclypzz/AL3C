import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  home: Scaffold(
    appBar: AppBar(
      title: Text("BRING IT"),
      centerTitle: true,
    ),
    body: Center(
      child: Text("Rendre service vous rend service!"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        child: Text("click"),
      ),
  ),
));

