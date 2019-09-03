import 'package:flutter/material.dart';
import 'shoppinglistscreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping List Flutter',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ShoppingListScreen(title: 'Shopping List'),
    );
  }
}


