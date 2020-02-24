import 'package:flutter/material.dart';
import 'package:silverkeep/db/models/Transaction.dart';

class TransactionsFragment extends StatefulWidget {
  TransactionsFragment({Key key}) : super(key: key);

  @override
  _TransactionsFragmentState createState() => _TransactionsFragmentState();
}

class _TransactionsFragmentState extends State<TransactionsFragment> {

  @override
  void initState() {
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Transaction.getPaginated(),
      builder: (BuildContext bc, AsyncSnapshot<dynamic> snapshot){
        return Center(
          child: Text('data'),
        );
      }
    );
  }

}
