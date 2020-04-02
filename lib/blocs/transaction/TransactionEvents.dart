import 'package:silverkeep/db/models/Transaction.dart';

abstract class TransactionEvent {}

class LoadTransactions extends TransactionEvent{
  final int offset;
  final int limit;
  final bool clearOldTransactions;
  final void Function(List<Transaction> transactionAdded) onAfterLoad;

  LoadTransactions({this.offset=0,this.limit=50,this.clearOldTransactions=true,this.onAfterLoad});
}

class LoadTransactionsRepeat extends TransactionEvent{
  final int offset;
  final int limit;
  final bool clearOldTransactions;
  final void Function(List<Transaction> transactionAdded) onAfterLoad;

  LoadTransactionsRepeat({this.offset=0,this.limit=50,this.clearOldTransactions=true,this.onAfterLoad});
}

class AddTransaction extends TransactionEvent{
  final Transaction transaction;
  
  final void Function(int id) onSave;
  final void Function(dynamic error)  onError;

  AddTransaction(this.transaction,{this.onSave,this.onError});
}

class EditTransaction extends TransactionEvent{
  final Transaction transaction;
  
  final void Function() onEdit;
  final void Function(dynamic error)  onError;

  EditTransaction(this.transaction,{this.onEdit,this.onError});
}

class DeleteTransaction extends TransactionEvent{
  final int id;
  
  final void Function() onDelete;
  final void Function(dynamic error)  onError;

  DeleteTransaction(this.id,{this.onDelete,this.onError});
}

class ChangeVisibleAmount extends TransactionEvent{
  final bool visibleAmount;

  ChangeVisibleAmount(this.visibleAmount);

}