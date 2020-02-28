import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:silverkeep/utils/NumberInputFormatter2.dart';

class TransactionPage extends StatefulWidget {
  TransactionPage({Key key}) : super(key: key);

  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nueva Transacción'),
        actions: <Widget>[
          FlatButton(
            child: Text('Guardar'),
            textColor: Theme.of(context).primaryTextTheme.title.color,
            onPressed: _save
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title:TextField(
              style: Theme.of(context).textTheme.headline,
              keyboardType: TextInputType.numberWithOptions(signed: true,decimal: true),
              decoration: InputDecoration.collapsed(
                hintText: 'Monto',
                border: InputBorder.none,
                hintStyle: Theme.of(context).textTheme.headline.copyWith(color:Theme.of(context).hintColor)
              ),
              inputFormatters: [
                NumberInputFormatter2(
                  decimalSeparator: '.',
                  thousandsSeparator: ',',
                  decimalRange: 5,
                  signed: true
                )
              ],
            )
          ),
          _buildDivider(),
          ListTile(
            leading: Icon(MdiIcons.walletOutline),
            title: Text(''),
            trailing: Icon(MdiIcons.bankTransferOut,color: Colors.red),
            onTap: _onTabDate,
          ),
          ListTile(
            leading: Icon(MdiIcons.walletOutline),
            title: Text(''),
            trailing: Icon(MdiIcons.bankTransferIn,color: Colors.green),
            onTap: _onTabDate,
          ),
          _buildDivider(),
          ListTile(
            leading: Icon(Icons.date_range),
            title: Text('Fecha'),
            onTap: _onTabDate,
          ),
          ListTile(
            leading: Icon(Icons.repeat),
            title: Text('Se repite'),
            onTap: _onTabDate,
          ),
          ListTile(
            leading: Icon(Icons.notifications_none),
            title: Text('Notificacion'),
            onTap: (){},
          ),
          _buildDivider(),
          ListTile(
            leading: Icon(Icons.label_outline),
            title: Wrap(
              spacing: 10,
              children: <Widget>[
                Chip(
                  label: Text('Entretenimiento'),
                  backgroundColor: Colors.transparent,
                  shape: StadiumBorder(side: BorderSide(color: Colors.grey)),
                ),
                Chip(
                  label: Text('Sueldo'),
                  backgroundColor: Colors.transparent,
                  shape: StadiumBorder(side: BorderSide(color: Colors.grey)),
                ),
              ],
            ),
            //isThreeLine: true,
            onTap: (){},
          ),
          ListTile(
            leading: Icon(Icons.subject),
            title: TextField(
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration.collapsed(
                hintText: 'Notas',
              ),
            ),
          ),
          SizedBox(
            height: 150,
          )
        ],
      ),
    );
  }

  Widget _buildDivider()=>Divider();

  _onTabDate(){

  }

  _save(){

  }
}