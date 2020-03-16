import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:silverkeep/blocs/transaction/TransactionBloc.dart';
import 'package:silverkeep/blocs/transaction/TransactionState.dart';
import 'package:silverkeep/db/models/Transaction.dart';
import 'package:silverkeep/modules/transactions/TransactionItem.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import "package:collection/collection.dart";

class TransactionsFragment extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc,TransactionState>(
      builder: (BuildContext context,TransactionState state){
        if(state.transactions.length==0)return Center(
          child: Text('Agregue una transación'),
        );

        Map<String,List<Transaction>> transactionGrouped=groupBy(state.transactions,(Transaction obj)=> DateFormat.yMMMd().format(obj.date) );
      

        return ListView.builder(
          padding: EdgeInsets.only(bottom: 100),
          itemCount: transactionGrouped.length,
          itemBuilder: (context,index){
            return StickyHeader(
              header: Container(
                color: Colors.grey.shade200,
                padding: EdgeInsets.symmetric(horizontal: 16,vertical: 11),
                width: double.maxFinite,
                child: Text( transactionGrouped.keys.toList()[index] ,
                  style: TextStyle(color: Colors.grey.shade800),
                )
              ),
              content: Column(
                children: transactionGrouped[transactionGrouped.keys.toList()[index]].map((Transaction t){
                  return TransactionItem(
                    transaction: t,
                  );
                }).toList(),
                // children: [
                //   TransactionItem(
                //     transaction: state.transactions[index],
                //   )
                // ],
              ),
            );
          },
        );
      },
    );
  }
}
