import 'package:flutter/material.dart';

class TransactionAppBar extends StatelessWidget {
  const TransactionAppBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Transacciones'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.filter_list),
          onPressed: (){
            
          }
        )
      ],
    );
  }
}