import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shoppingapp/shoppingitem.dart';
import 'package:http/http.dart' as http;

class ShoppingListScreen extends StatefulWidget {
  ShoppingListScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ShoppingListScreenState createState() => new _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  final String _getUrl = 'https://borda-shopping.now.sh/items';
  final String _postUrl = 'https://borda-shopping.now.sh/items/new';
  List<ShoppingItem> _shoppingItems = List();
  final TextEditingController _textEditingController =
      new TextEditingController();

  @override
  initState() {
    _getRequest(_getUrl).then((value) => _shoppingItems = value);

    super.initState();
  }

  _handleSubmitted(String text) async {
    _textEditingController.clear();
  }

  _getRequest(String url) async {
    var response = await http.get(url);
    print(response.statusCode);
    print(response.body);

    return (json.decode(response.body) as List).map((e) => ShoppingItem.fromJson(e)).toList();
  }

  _postRequest(String url, {Map body}) async {
    var response = await http.post(url,
    headers: {"Content-Type": "application/json"},
    body: json.encode(body));

    print(response.statusCode);
    print(response.body);

    return response;
  }

  _deleteRequest(String url, String id) async {
    var response = await http.delete("$url/$id");

    print(response.statusCode);
    print(response.body);
  }

  void _addShoppingItem() {
    var alert = new AlertDialog(
      content: new Row(
        children: <Widget>[
          new Expanded(
              child: new TextField(
            controller: _textEditingController,
            autofocus: true,
            decoration: new InputDecoration(
                labelText: "Item",
                labelStyle: TextStyle(color: Colors.deepOrange),
                hintText: "Insert your need here ",
                icon: new Icon(
                  Icons.note_add,
                  color: Colors.deepOrange,
                )),
          ))
        ],
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: () {
              _postRequest(_postUrl, body: {"item":_textEditingController.text});
              setState(() {
                _getRequest(_getUrl).then((value) => _shoppingItems = value);
              });
              _handleSubmitted(_textEditingController.text);
              _textEditingController.clear();
            },
            child: Text(
              'Add',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.deepOrange),
            )),
        new FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.deepOrange),
            ))
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  @override
  Widget build(BuildContext context) {
    final shoppingItemWidgets =
        _shoppingItems.map(_createShoppingItemWidget).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping List'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Stack(
        children: [
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width / 2.5,
              child: ListView(
                children: shoppingItemWidgets,
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomLeft,
            padding: EdgeInsets.only(bottom: 50),
            child: IconButton(
              icon: Icon(Icons.delete_forever, size: 82.0),
              color: Colors.deepOrange,
              onPressed: () => _displayDeleteConfirmationDialog(),
            ),
          ),
        ],
      ),
      // MediaQuery.of(context).size.width
      //ListView(
      //children: shoppingItemWidgets,),
      /*Container(
            alignment: Alignment.bottomLeft,
            padding: EdgeInsets.only(bottom: 50),
            child: IconButton(
              icon: Icon(Icons.delete_forever, size: 82.0),
              color: Colors.deepOrange,
              onPressed: () => _displayDeleteConfirmationDialog(),
            ))*/

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        onPressed: _addShoppingItem,
        tooltip: 'Add Item',
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _createShoppingItemWidget(ShoppingItem shoppingItem) {
    return ListTile(
      title: Text(shoppingItem.item),
      contentPadding: EdgeInsets.all(16.0),
      trailing: Checkbox(
        checkColor: Colors.white,
        activeColor: Colors.deepOrange,
        value: shoppingItem.isComplete,
        onChanged: (value) => _updateShoppingCompleteStatus(shoppingItem, value),
      ),
    );
  }

  void _updateShoppingCompleteStatus(ShoppingItem item, bool newStatus) {
    /*final tempShoppingItems = _shoppingItems;
    tempShoppingItems.firstWhere((i) => i.id == item.id).isComplete = newStatus;
    setState(() {
      _shoppingItems = tempShoppingItems;
    });*/
    setState(() {
      item.isComplete = newStatus;
    });
  }

  void _deleteShoppingItem() {
    /*List tempShoppingItems = _shoppingItems;
    List willDelete =
        _shoppingItems.where((value) => value.isComplete).toList();

    for (var i = 0; i < willDelete.length; i++) {
      tempShoppingItems.remove(willDelete[i]);
    }
    setState(() {
      _shoppingItems = tempShoppingItems;
    });*/

    for (int i = 0; i < _shoppingItems.length; i++) {
      if (_shoppingItems[i].isComplete == true) {
        _deleteRequest(_getUrl, _shoppingItems[i].id);
      }
    }

    setState(() {
      _getRequest(_getUrl).then((value) => _shoppingItems = value);
    });

    // setState(() {
    //   _shoppingItems.removeWhere((item) => item.isComplete);
    // });
  }

  Future<Null> _displayDeleteConfirmationDialog() {
    return showDialog<Null>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Delete item", style: TextStyle(color: Colors.black87)),
            content: Text("Do you want to delete selected items?"),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.deepOrange),
                ),
                onPressed: Navigator.of(context).pop,
              ),
              FlatButton(
                child: Text(
                  "Delete",
                  style: TextStyle(color: Colors.deepOrange),
                ),
                onPressed: () {
                  _deleteShoppingItem();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
