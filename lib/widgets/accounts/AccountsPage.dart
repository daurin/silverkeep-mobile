import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'AccountPage.dart';

class AccountsPage extends StatefulWidget {
  AccountsPage({Key key}) : super(key: key);

  @override
  _AccountsPageState createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('Cuentas'),
        actions: <Widget>[
          IconButton(
            icon: Icon(MdiIcons.eyeOutline),
            onPressed: (){

            },
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          _buildAccountItem(name: 'Billetera',color: Colors.green),
          Divider(height: 1,),
          _buildAccountItem(name: 'Cuenta de ahorro banco popular',color: Colors.yellow)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AccountPage()),
          );
        }
      ),
    );
  }

  _buildAccountItem({String name,Color color=Colors.white}){
    return ListTile(
      leading: CircleAvatar(
        child: Text(name.substring(0,1),),
        backgroundColor: color,
        //foregroundColor: color,
      ),
      title: Text(name),
      trailing: Text('\$100,000',style: TextStyle(fontSize: 16,color:Colors.green[400]),),
    );
  }
}