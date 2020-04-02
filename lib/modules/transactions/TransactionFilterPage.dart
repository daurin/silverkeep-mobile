import 'package:flutter/material.dart';

class TransactionFilterPage extends StatefulWidget {
  TransactionFilterPage({Key key}) : super(key: key);

  @override
  _TransactionFilterPageState createState() => _TransactionFilterPageState();
}

class _TransactionFilterPageState extends State<TransactionFilterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filtros de búsqueda'),
        actions: <Widget>[
          ButtonBar(
            children: <Widget>[
              FlatButton(
                child: Text('Aplicar'),
                onPressed: _apply,
              )
            ],
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            isThreeLine: false,
            title: Text('Tipo'),
            trailing: Wrap(
              spacing: 5,
              children: <Widget>[
                ChoiceChip(
                  label: Text('Ingreso'),
                  selected: true,
                  onSelected: (bool selected){},
                ),
                ChoiceChip(
                  label: Text('Gasto'),
                  selected: false,
                  onSelected: (bool selected){},
                ),
                ChoiceChip(
                  label: Text('Transferencia'),
                  selected: true,
                  onSelected: (bool selected){},
                ),
              ],
            ),
          ),
          ListTile(
            title: Text('Ordenar por'),
            subtitle: Text('Fecha'),
            onTap: _onTabOrder,
          ),
          ListTile(
            title: Text('Orden'),
            subtitle: Text('Accendente'),
            onTap: _onTabOrder,
          ),
          ListTile(
            title: Text('Cuentas')
          ),
          ListTile(
            title: Text('Etiquetas')
          )
        ],
      ),
    );
  }

  void _onTabOrder(){

  }

  void _apply(){

  }
}