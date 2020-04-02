import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:silverkeep/blocs/transaction/TransactionBloc.dart';
import 'package:silverkeep/blocs/transaction/TransactionEvents.dart';
import 'package:silverkeep/blocs/transaction/TransactionState.dart';
import 'package:silverkeep/db/models/Transaction.dart';
import 'package:silverkeep/modules/transactions/TransactionItem.dart';
import 'package:silverkeep/modules/transactions/TransactionRecurrentsPage.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

import 'TransactionPage.dart';

class TransactionsFragment extends StatefulWidget {

  final ScrollController scrollController;

  const TransactionsFragment({Key key,this.scrollController}) : super(key: key);

  @override
  _TransactionsFragmentState createState() => _TransactionsFragmentState();
}

class _TransactionsFragmentState extends State<TransactionsFragment> with AutomaticKeepAliveClientMixin{

  ScrollController _scrollController;
  TransactionBloc _transactionBloc;
  //int _lastOffset;
  bool _isTransactionEnd=false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _transactionBloc = BlocProvider.of<TransactionBloc>(context);
    _transactionBloc.listen((TransactionState state){
      if(state.lastOffset==0 && !state.loading && _scrollController.position.pixels!=0){
        _scrollController.jumpTo(0);
        setState(()=>_isTransactionEnd=false);
      }
    });

    _scrollController=widget.scrollController??ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<TransactionBloc,TransactionState>(
      condition: (oldState,newState){
        return
          oldState.transactions.length!=newState.transactions.length ||
          oldState.loading!=newState.loading ||
          oldState.transactionsRepeat.length!=newState.transactionsRepeat.length ||
          oldState.visibleAmount!=newState.visibleAmount;
      },
      builder: (BuildContext context,TransactionState state){
        if(state.transactions.length==0 && state.transactionsRepeat.length==0 && 
          state.loading==false) return Column(
            children: <Widget>[
              Visibility(
                visible: state.visibleAmount,
                child: _totalInfo(),
              ),
              Expanded(
                child: Center(
                  child: Text('Agregue una transación'),
                ),
              ),
            ],
          );


        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Visibility(
              visible: state.visibleAmount,
              child: _totalInfo(),
            ),
            Visibility(visible: state.visibleAmount,child: Divider(height: 0,)),
            Expanded(
              child: Scrollbar(
                child: ListView(
                  controller: _scrollController,
                  children: [
                    Visibility(
                      visible: state.transactionsRepeat.length>0,
                      child: ListTile(
                        title: Text('Recurrentes'),
                        trailing: Icon(MdiIcons.clipboardListOutline),
                        onTap: _onTabRecurrent,
                      ),
                    ),
                    Visibility(visible: state.transactionsRepeat.length>0,child: Divider(height: 0,)),
                    ListTile(
                      title: Text('Historial'),
                      //trailing: Text('25 transacciones el dia de hoy'),
                    ),
                    ...state.transactions.map((Transaction transaction){
                      return TransactionItem(
                        transaction: transaction,
                        onTab: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>TransactionPage(
                            id: transaction.id,
                          )));
                        },
                      );
                    }).toList(),
                    Visibility(
                      visible: state.loading,
                      child: Container(
                        height: 110,
                        child: Center(child: CircularProgressIndicator())
                      )
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _scrollListener() {
    TransactionState state =_transactionBloc.state;
    if(_scrollController.position.pixels>=_scrollController.position.maxScrollExtent-1700 && 
      !state.loading && !_isTransactionEnd){
      _transactionBloc.add(LoadTransactions(
        offset: state.lastOffset+50,
        limit: 50,
        clearOldTransactions: false,
        onAfterLoad: (added){
          if(added.length==0)setState(()=>_isTransactionEnd=true);
        }
      ));
      // setState(() {
      //   _lastOffset=_lastOffset+50;
      // });
    }
  }

  Widget _totalInfo(){
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.symmetric(vertical: 13,horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(MdiIcons.walletOutline,size: 16,),
              Text(' 46,313,158'),
            ],
          ),
          Row(
            children: <Widget>[
              Icon(Icons.trending_up,size: 16,color: Colors.green,),
              Text(' 46,313,158'),
            ],
          ),
          Row(
            children: <Widget>[
              Icon(Icons.trending_down,size: 16,color: Colors.red,),
              Text(' 46,313,158'),
            ],
          )
        ],
      ),
    );
  }

  void _onTabRecurrent() {
    Navigator.push(context, MaterialPageRoute(builder: (context)=>TransactionRecurretnsPage(

    )));
  }
} 
