import 'package:flutter/material.dart';

class DialingsAppBar extends StatelessWidget {
  const DialingsAppBar({Key key}) : super(key: key);

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