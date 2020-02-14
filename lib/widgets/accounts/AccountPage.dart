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
            // leading: Visibility(
            //   visible: false,
            //   maintainAnimation: true,
            //   maintainSemantics: true,
            //   maintainSize: true,
            //   maintainState: true,
            //   child: Icon(Icons.title)
            // ),
            title: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 800,
              ),
              child: TextField(
                controller: TextEditingController(text: 'Cuenta de banco popular Dominicano'),
                maxLines: null,
                style: Theme.of(context).textTheme.headline,
                decoration: InputDecoration(
                  hintText: 'Titulo',
                  border: InputBorder.none,
                  hintStyle: Theme.of(context).textTheme.headline.copyWith(color:Theme.of(context).hintColor)
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
                //ThousandsFormatter()
                NumberInputFormatter2(
                  decimalSeparator: '.',
                  thousandsSeparator: ',',
                  decimalRange: 2,
                  signed: true
                )
              ],
                keyboardType: TextInputType.numberWithOptions(signed: true,decimal: true),
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