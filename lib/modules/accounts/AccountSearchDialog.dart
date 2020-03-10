import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:silverkeep/db/models/Account.dart';
import 'package:silverkeep/modules/shared/colors/ColorsApp.dart';

class AccountSearchDialog extends StatefulWidget {
  AccountSearchDialog({Key key}) : super(key: key);

  @override
  _AccountSearchDialogState createState() => _AccountSearchDialogState();
}

class _AccountSearchDialogState extends State<AccountSearchDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      //titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.symmetric(horizontal: 0,vertical: 20),
      title: Text('Cuentas'), 
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // ListTile(
          //   title: TextField(
          //     decoration: InputDecoration.collapsed(
          //       hintText: 'Buscar'
          //     ),
          //   ),
          //   trailing: IconButton(
          //     icon: Icon(Icons.search),
          //     onPressed: (){
              
          //     }
          //   ),
          // ),
          // Divider(height: 1,),
          FutureBuilder(
            future: Account.getAll(),
            builder: (BuildContext context,AsyncSnapshot<List<Account>> snapshot){
              if(snapshot.connectionState==ConnectionState.waiting)
                return Container();

              if(snapshot.data.length==0){
                return Center(
                  child: Text('No hay cuentas'),
                );
              }
              else{
                return Column(
                  children: snapshot.data.map((Account account){
                    return ListTile(
                      leading: Icon(MdiIcons.walletOutline
                        ,color: ColorsApp(context).getColorDataByKey(account.color)['color']),
                      title:Text(account.name),
                      onTap: (){
                        Navigator.of(context).pop(account);
                      },
                    );
                  }).toList(),
                );
              }
          }),
        ],
      ),
    );
  }
}