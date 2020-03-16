import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silverkeep/db/models/Transaction.dart';
import 'TransactionEvents.dart';
import 'TransactionState.dart';

class TransactionBloc extends Bloc<TransactionEvent,TransactionState>{
  @override
  TransactionState get initialState => TransactionState.initial();

  @override
  Stream<TransactionState> mapEventToState(TransactionEvent event) async*{
    if(event is LoadTransactions){
      yield* _loadTransactions();
    }
    if(event is AddTransaction){
      _addTransaction(event);
    }
  }

  _addTransaction(AddTransaction event){
    Transaction.add(event.transaction)
      .then((int id){
        event?.onSave(id);
        add(LoadTransactions());
      })
      .catchError((error){
        print(error);
        event?.onError(error);
      });

  }

  Stream<TransactionState> _loadTransactions()async*{
    List<Transaction> transactions= await Transaction.select();
    yield state.copyWith(transactions: transactions);
  }

}