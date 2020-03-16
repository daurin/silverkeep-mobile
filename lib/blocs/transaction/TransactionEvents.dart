import 'package:silverkeep/db/models/Transaction.dart';

abstract class TransactionEvent {}

class LoadTransactions extends TransactionEvent{}

class AddTransaction extends TransactionEvent{
  final Transaction transaction;
  final void Function(int id) onSave;
  final void Function(dynamic error)  onError;

  AddTransaction(this.transaction,{this.onSave,this.onError});
}