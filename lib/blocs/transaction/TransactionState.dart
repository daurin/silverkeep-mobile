import 'package:equatable/equatable.dart';
import 'package:silverkeep/db/models/Transaction.dart';

class TransactionState extends Equatable{

  final List<Transaction> transactions;
  final List<Transaction> transactionsRepeat;
  final Map<String,List<Transaction>> transactionGrouped;
  final bool loading;
  final int lastOffset;
  
  final bool loadingRepeat;
  final int lastOffsetRepeat;

  final bool visibleAmount;


  TransactionState({this.transactions,this.transactionGrouped,this.transactionsRepeat,this.loading,
  this.loadingRepeat,this.lastOffset,this.lastOffsetRepeat,this.visibleAmount});

  TransactionState copyWith({
    List<Transaction> transactions,
    List<Transaction> transactionGrouped,
    List<Transaction> transactionRepeat,
    bool loading,
    bool loadingRepeat,
    int lastOffset,
    int lastOffsetRepeat,
    bool visibleAmount
  })=>TransactionState(
    transactions: transactions ?? this.transactions,
    transactionsRepeat: transactionRepeat ?? this.transactionsRepeat,
    transactionGrouped: transactionGrouped ?? this.transactionGrouped,
    loading: loading ?? this.loading,
    loadingRepeat: loadingRepeat ?? this.loadingRepeat,
    lastOffset: lastOffset ?? this.lastOffset,
    lastOffsetRepeat: lastOffsetRepeat ?? this.lastOffsetRepeat,
    visibleAmount: visibleAmount ?? this.visibleAmount,
  );

  static TransactionState initial(){
    return TransactionState(
      transactions: [],
      transactionGrouped: {},
      transactionsRepeat: [],
      loading: false,
      loadingRepeat: false,
      lastOffset: 0,
      lastOffsetRepeat: 0,
      visibleAmount: true,
    );
  }

  @override
  List<Object> get props => [transactions,transactionGrouped,transactionsRepeat,loading,loadingRepeat,
    lastOffset,lastOffsetRepeat,visibleAmount];
}

class TransactionFilter{
  
}