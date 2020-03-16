import 'package:silverkeep/db/models/Account.dart';

import '../DB.dart';
import 'package:intl/intl.dart';

import 'Label.dart';
import 'TransactionLabel.dart';

class Transaction{

  int id;
  int idUser;
  Account account;
  Account accountTransfer;
  double amount;
  String description;
  String notes;
  TransactionType transactionType;
  TransactionRepeatMode repeatMode;
  TransactionRepeatEvery repeatEvery;
  int repeatCount;
  DateTime date;
  DateTime dateFinish;
  bool monday;
  bool tuesday;
  bool wednesday;
  bool thursday;
  bool friday;
  bool saturday;
  bool sunday;
  NotifyTimeType notifyTimeType;
  int notifyTimes;
  List<Label> labels;



  static String tableName = 'TRANSACTION';

  Transaction({this.id, this.idUser,this.account,this.accountTransfer,this.amount,this.description,this.notes,this.transactionType,
  this.repeatMode,this.repeatEvery,this.repeatCount,this.date,
  this.dateFinish,this.monday=false,this.tuesday=false,this.wednesday=false,this.thursday=false,
  this.friday=false,this.saturday=false,this.sunday=false,
  this.notifyTimeType,this.notifyTimes,this.labels});

  Map<String, dynamic> toMap({ignoreId=false}) {
    Map<String, dynamic> map = {
      'id': id,
      'id_user': idUser,
      'id_account': account.id,
      'id_account_transfer': accountTransfer?.id??null,
      'amount':amount,
      'description':description,
      'notes':notes,
      'transaction_type':(){
        switch (transactionType) {
          case TransactionType.Income: return 'I';
          case TransactionType.Expense:return 'E';
          case TransactionType.Transfer: return 'T';
          default: return null;
        }
      }(),
      'repeat_mode':(){
        switch (repeatMode) {
          case TransactionRepeatMode.NotRepeat: return 'notRepeat';
          case TransactionRepeatMode.EveryDay: return 'everyDay';
          case TransactionRepeatMode.EveryWeek: return 'everyWeek';
          case TransactionRepeatMode.EveryMonth: return 'everyMonth';
          case TransactionRepeatMode.EveryYear: return 'everyYear';
          case TransactionRepeatMode.Custom: return 'custom';
          default: return null;
        }
      }(),
      'repeat_every':(){
        switch (repeatEvery) {
          case TransactionRepeatEvery.Days:return 'days';
          case TransactionRepeatEvery.Weeks:return 'weeks';
          case TransactionRepeatEvery.Months:return 'months';
          case TransactionRepeatEvery.Years:return 'years';
          default: return null;
        }
      }(),
      'repeat_count':repeatCount,
      'date':DateFormat('yyyy-MM-dd-hh:mm').format(date),
      'date_finish':dateFinish==null?null:DateFormat('yyyy-MM-dd-hh:mm').format(dateFinish),
      'monday':this.monday?1:0,
      'tuesday':this.tuesday?1:0,
      'wednesday':this.wednesday?1:0,
      'thursday':this.thursday?1:0,
      'friday':this.friday?1:0,
      'saturday':this.saturday?1:0,
      'sunday':this.sunday?1:0,
      'notify_time_type':(){
        switch (notifyTimeType) {
          case NotifyTimeType.Minutes:return 'months';
          case NotifyTimeType.Hours:return 'years';
          case NotifyTimeType.Days:return 'days';
          case NotifyTimeType.Weeks:return 'weeks';
          default: return null;
        }
      }(),
      'notify_times':this.notifyTimes
    };

    if(ignoreId)map.remove('id');
    return map;
  }

  String getTitleRepeat(){
    switch (repeatMode) {
      case TransactionRepeatMode.NotRepeat: return 'No se repite';
      case TransactionRepeatMode.EveryDay: return 'Todos los dias';
      case TransactionRepeatMode.EveryWeek: return 'Todas las semanas';
      case TransactionRepeatMode.EveryMonth: return 'No se Todos los meses';
      case TransactionRepeatMode.EveryYear: return 'Todos los años';
      case TransactionRepeatMode.Custom:
        String label='Se repite ';
        if(repeatEvery==TransactionRepeatEvery.Days)label+='cada $repeatCount dias';
        if(repeatEvery==TransactionRepeatEvery.Weeks)label+='cada $repeatCount semanas';
        if(repeatEvery==TransactionRepeatEvery.Months)label+='cada $repeatCount meses';
        if(repeatEvery==TransactionRepeatEvery.Years)label+='cada $repeatCount años';
        return label;
      default: return 'Todos los dias';
    }
  }

  static Transaction fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      idUser: map['id_user'],
      //account: map['id_account'],
      //accountTransfer: map['id_account_transfer'],
      amount: double.parse(map['amount'].toString()),
      description: map['description'],
      notes: map['notes'],
      transactionType:(){
        switch (map['transaction_type']) {
          case 'I': return TransactionType.Income;
          case 'E': return TransactionType.Expense;
          case 'T': return TransactionType.Transfer;
          default: return null;
        }
      }(),
      repeatMode: (){
        switch (map['repeat_mode']) {
          case 'notRepeat':return TransactionRepeatMode.NotRepeat;
          case 'everyDay':return TransactionRepeatMode.EveryDay;
          case 'everyWeek':return TransactionRepeatMode.EveryWeek;
          case 'everyMonth':return TransactionRepeatMode.EveryMonth;
          case 'everyYear':return TransactionRepeatMode.EveryYear;
          case 'custom':return TransactionRepeatMode.Custom;
          default: return null;
        }
      }(),
      repeatEvery:(){
        switch (map['repeat_every']) {
          case 'days': return TransactionRepeatEvery.Days;
          case 'months': return TransactionRepeatEvery.Months;
          case 'days': return TransactionRepeatEvery.Years;
          case 'years': return TransactionRepeatEvery.Years;
          default: return null;
        }
      }(),
      date: DateFormat('yyyy-MM-dd').parse(map['date']),
      dateFinish:map['date_finish']==null? null : DateFormat('yyyy-MM-dd').parse(map['date_finish']),
      monday: map['monday']=='1',
      tuesday: map['tuesday']=='1',
      wednesday: map['wednesday']=='1',
      thursday: map['thursday']=='1',
      friday: map['friday']=='1',
      saturday: map['saturday']=='1',
      sunday: map['sunday']=='1',
      notifyTimeType: (){
        switch (map['notify_time_type']) {
          case 'minutes': return NotifyTimeType.Minutes;
          case 'hours': return NotifyTimeType.Hours;
          case 'days': return NotifyTimeType.Days;
          case 'weeks': return NotifyTimeType.Weeks;
          default: return null;
        }
      }()
    );
  }

  static Future<int> add(Transaction transaction)async{
    final db=DB.db;
    return await db.insert(tableName,transaction.toMap(ignoreId: true))
      .then((int id)async{
        for (Label item in transaction.labels) {
          await TransactionLabel.add(TransactionLabel(
            idTransaction: id,
            idLabel: item.id
          ));
        }
        return await Future.value(id);
      });
  }

  static Future<int> editById(Transaction transaction,int id){
    final db=DB.db;

    return db.update(Transaction.tableName,transaction.toMap(ignoreId: true),
      where: 'id = ?',whereArgs: [id]
    );
  }

  // static Future<List<Transaction>> getAll({String orderBy='id asc'})async{
  //   final  db=DB.db;

  //   return db.query(Transaction.tableName,orderBy: orderBy)
  //     .then((res){
  //       if(res.length>0){
  //         return res.map((v)=>Transaction.fromMap(v)).toList();
  //       }
  //       else return [];
  //     });
  // }

  static Future<List<Transaction>> select({String orderBy='date desc,id desc'})async{
    final  db=DB.db;

    return await db.query(Transaction.tableName,orderBy: orderBy)
      .then((res)async{
        if(res.length>0){
          List<Transaction> transactions= res.map((v)=>Transaction.fromMap(v)).toList();

          for (int i = 0; i < transactions.length; i++) {
            transactions[i].account=await Account.findById(int.parse(res[i]['id_account'].toString()));
            if(res[i]['id_account_transfer']!=null)
              transactions[i].accountTransfer=await Account.findById(int.parse(res[i]['id_account_transfer'].toString()));

          }
          
          for (var item in transactions) {
            item.labels=await Label.findByTransactionId(item.id);
          }          
          // transactions.sort((a, b){
          //   return b.date.compareTo(b.date);
          // });
          return transactions;
        }
        else return [];
      });
  }

  static Future<Transaction> findById(int id)async{
    final  db=DB.db;

    return await db.query(Transaction.tableName,where: 'id = ?',whereArgs: [id])
      .then((res)async{
        if(res.length>0){
          Transaction transaction= Transaction.fromMap(res[0]);

          transaction.account=await Account.findById(int.parse(res[0]['id_account'].toString()));
          if(res[0]['id_account_transfer']!=null)
            transaction.accountTransfer=await Account.findById(int.parse(res[0]['id_account_transfer'].toString()));
          transaction.labels=await Label.findByTransactionId(transaction.id);
          return transaction;
        }
        else return null;
      });
  }

  static Future<void> deleteById(int id)async{
    final  db=DB.db;
    return db.delete(Transaction.tableName,where: 'id = ?',whereArgs: [id]);
  }

}

enum TransactionType{
  Transfer,
  Income,
  Expense
}

enum TransactionRepeatMode{
  NotRepeat,
  EveryDay,
  EveryWeek,
  EveryMonth,
  EveryYear,
  Custom
}

enum TransactionRepeatEvery{
  Days,
  Weeks,
  Months,
  Years
}

enum NotifyTimeType{
  Minutes,
  Hours,
  Days,
  Weeks
}