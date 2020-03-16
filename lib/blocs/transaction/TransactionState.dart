import 'package:equatable/equatable.dart';
import 'package:silverkeep/db/models/Transaction.dart';

class TransactionState extends Equatable{

  final List<Transaction> transactions;

  TransactionState({this.transactions});

  TransactionState copyWith({
    List<Transaction> transactions
  })=>TransactionState(
    transactions: transactions ?? this.transactions
  );

  static TransactionState initial(){
    return TransactionState(
      transactions: []
    );
  }

  @override
  List<Object> get props => [transactions];
}