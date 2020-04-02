import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:silverkeep/db/models/Transaction.dart';
import 'package:silverkeep/services/SharedPrefService.dart';
import 'TransactionEvents.dart';
import 'TransactionState.dart';

class TransactionBloc extends Bloc<TransactionEvent,TransactionState>{
  @override
  TransactionState get initialState => TransactionState.initial();

  @override
  Stream<TransactionState> mapEventToState(TransactionEvent event) async*{
    if(event is LoadTransactions){
      yield* _loadTransactions(event);
    }
    if(event is LoadTransactionsRepeat){
      yield* _loadTransactionsRepeat(event);
    }
    if(event is AddTransaction){
      _addTransaction(event);
    }
    if(event is EditTransaction){
      _editTransaction(event);
    }
    if(event is DeleteTransaction){
      _deleteTransaction(event);
    }
    if(event is ChangeVisibleAmount){
      SharedPrefService().showAmount=event.visibleAmount;
      yield state.copyWith(visibleAmount: event.visibleAmount);
    }
  }

  void _addTransaction(AddTransaction event){
    Transaction.add(event.transaction)
      .then((int id){
        event?.onSave(id);
      })
      .catchError((error){
        event?.onError(error);
      });
  }

  void _editTransaction(EditTransaction event){
    Transaction.editById(event.transaction)
      .then((v){
        event?.onEdit();
      })
      .catchError((error){
        event?.onError(error);
      });
  }

  void _deleteTransaction(DeleteTransaction event){
    Transaction.deleteById(event.id)
      .then((v){
        event?.onDelete();
      })
      .catchError((error){
        event?.onError(error);
      });
  }

  Stream<TransactionState> _loadTransactions(LoadTransactions event)async*{
    yield state.copyWith(loading: true);

    List<Transaction> transactions=state.transactions.toList();
    Map<String,List<Transaction>> transactionsGrouped;

    List<Transaction> newTransactions=await Transaction.select(
      offset: event.offset,
      limit: event.limit,
      repeatModes: [TransactionRepeatMode.NotRepeat]
    );
    if(event.clearOldTransactions)transactions.clear();
    
    transactions.addAll(newTransactions);
    // transactionsGrouped=groupBy(transactions,(Transaction transaction){
    //   return DateFormat.yMEd().format(transaction.date);
    // });

    if(event.onAfterLoad !=null)event.onAfterLoad(newTransactions);

    yield state.copyWith(transactions: transactions,loading: false,lastOffset: event.offset);
  }

  Stream<TransactionState> _loadTransactionsRepeat(LoadTransactionsRepeat event)async*{
    yield state.copyWith(loadingRepeat: true);

    List<Transaction> transactions=state.transactionsRepeat.toList();

    List<TransactionRepeatMode> repeatModes=TransactionRepeatMode.values.toList();
    repeatModes.removeWhere((item)=>item==TransactionRepeatMode.NotRepeat);
    
    List<Transaction> newTransactions=await Transaction.select(
      offset: event.offset,
      limit: event.limit,
      repeatModes: repeatModes
    );
    if(event.clearOldTransactions)transactions.clear();

    transactions.addAll(newTransactions);
    if(event.onAfterLoad !=null)event.onAfterLoad(newTransactions);
    
    yield state.copyWith(transactionRepeat: transactions,loadingRepeat: false,lastOffsetRepeat: event.offset);
  }

}