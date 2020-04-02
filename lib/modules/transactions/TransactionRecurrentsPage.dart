import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silverkeep/blocs/transaction/TransactionBloc.dart';
import 'package:silverkeep/blocs/transaction/TransactionEvents.dart';
import 'package:silverkeep/blocs/transaction/TransactionState.dart';
import 'package:silverkeep/modules/transactions/TransactionItem.dart';
import 'package:silverkeep/modules/transactions/TransactionPage.dart';

class TransactionRecurretnsPage extends StatefulWidget {
  TransactionRecurretnsPage({Key key}) : super(key: key);

  @override
  _TransactionRecurretnsPageState createState() => _TransactionRecurretnsPageState();
}

class _TransactionRecurretnsPageState extends State<TransactionRecurretnsPage> {

  TransactionBloc _transactionBloc;
  ScrollController _scrollController;
  bool _isTransactionEnd=false;

  @override
  void initState() {
    super.initState();

    _scrollController=ScrollController();
    _scrollController.addListener(_scrollListener);

    _transactionBloc = BlocProvider.of<TransactionBloc>(context);
    _transactionBloc.listen((state){
      if(state.transactionsRepeat.length==0 && !state.loadingRepeat){
        //Navigator.pop(context);
        return;
      }
      if(state.lastOffsetRepeat==0 && !state.loadingRepeat && _scrollController.position.pixels!=0){
        _scrollController.jumpTo(0);
        setState(()=>_isTransactionEnd=false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc,TransactionState>(
      condition: (oldState,newState){
        return 
          oldState.transactionsRepeat.length!=newState.transactionsRepeat.length ||
          oldState.loadingRepeat!=newState.loadingRepeat;
      },
      builder: (BuildContext context,TransactionState state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Recurrentes'),
          ),
          body: Scrollbar(
            child: ListView(
              controller: _scrollController,
              children: <Widget>[
                ...state.transactionsRepeat.map((transaction){
                  return TransactionItem(
                    transaction: transaction,
                    onTab: ()async{
                      await Navigator.push(context, MaterialPageRoute(builder: (context)=>TransactionPage(
                        id: transaction.id,
                      )));
                    },
                  );
                }).toList(),
                Visibility(
                  visible: state.loadingRepeat,
                  child: Container(
                    height: 110,
                    child: Center(child: CircularProgressIndicator())
                  )
                )
              ],
            )
          ),
        );
      }
    );
  }

  void _scrollListener() {
    TransactionState state =_transactionBloc.state;
    if(_scrollController.position.pixels>=_scrollController.position.maxScrollExtent-1700 && 
      !state.loadingRepeat && !_isTransactionEnd){
      _transactionBloc.add(LoadTransactionsRepeat(
        offset: state.lastOffsetRepeat+50,
        limit: 50,
        onAfterLoad: (added){
          if(added.length==0)setState(()=>_isTransactionEnd=true);
        }
      ));
      // setState(() {
      //   _lastOffset=_lastOffset+50;
      // });
    }
  }
}