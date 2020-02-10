import 'package:flutter/material.dart';
import 'package:silverkeep/widgets/shared/dialogs/ColorSelectDialog.dart';

class AccountPage extends StatefulWidget {
  AccountPage({Key key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('Nueva cuenta')
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.title),
            title: TextField(
              decoration: InputDecoration.collapsed(
                hintText: 'Titulo'
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.attach_money),
            title: TextField(
              decoration: InputDecoration.collapsed(
                hintText: 'Saldo'
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.color_lens,color: Colors.purpleAccent,),
            title: Text('Color'),
            onTap: _onTabColor,
          )
        ],
      )
    );
  }

  _onTabColor(){
    showDialog(
      context: context,
      builder: (BuildContext bc){
        return ColorSelectDialog();
      },
    );
  }
}