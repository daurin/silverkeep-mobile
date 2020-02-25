import 'package:flutter/material.dart';
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
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title:TextField(
              style: Theme.of(context).textTheme.headline,
              decoration: InputDecoration.collapsed(
                hintText: 'Monto',
                border: InputBorder.none,
                hintStyle: Theme.of(context).textTheme.headline.copyWith(color:Theme.of(context).hintColor)
              ),
              inputFormatters: [
                NumberInputFormatter2(
                  decimalSeparator: '.',
                  thousandsSeparator: ',',
                  decimalRange: 2,
                  signed: true
                )
              ],
            )
          ),
          Divider(height: 1,)
        ],
      ),
    );
  }
}