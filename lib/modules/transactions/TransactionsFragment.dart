import 'package:flutter/material.dart';
import 'package:silverkeep/db/models/Transaction.dart';
import 'package:silverkeep/modules/transactions/TransactionItem.dart';

class TransactionsFragment extends StatefulWidget {
  TransactionsFragment({Key key}) : super(key: key);

  @override
  _TransactionsFragmentState createState() => _TransactionsFragmentState();
}

class _TransactionsFragmentState extends State<TransactionsFragment> {

  List<Transaction> _transactions;

  @override
  void initState() {
    super.initState();

    _transactions=[];
    _loadTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _transactions.length,
      itemBuilder: (context,index){
        return TransactionItem(
          transaction: _transactions[index],
        );
      },
    );
  }


  void _loadTransactions(){
    Transaction.select()
      .then((List<Transaction> transactions){
        setState(() {
          _transactions.addAll(transactions);
        });
      });
  }
}
