import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:silverkeep/utils/NumberInputFormatter2.dart';
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
            title: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 800,
              ),
              child: TextField(
                maxLines: null,
                style: Theme.of(context).textTheme.title,
                decoration: InputDecoration.collapsed(
                  hintText: 'Titulo',
                  hintStyle: Theme.of(context).textTheme.title.copyWith(color:Theme.of(context).hintColor)
                ),
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.attach_money),
            title: TextField(
              //controller: ,
              inputFormatters: [
                //WhitelistingTextInputFormatter.digitsOnly,
                //ThousandsFormatter(allowFraction: true,//formatter: CustomFormat.numberWithDecimal())
                NumberInputFormatter2()
              ],
                keyboardType: TextInputType.number,
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