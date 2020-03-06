import '../DB.dart';
import 'package:intl/intl.dart';

class Transaction {

  int id;
  int idUser;
  int idAccount;
  int idAccountTransfer;
  double amount;
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


  static String tableName = 'TRANSACTION';

  Transaction({this.id, this.idUser,this.idAccount,this.idAccountTransfer,this.amount,this.notes,this.transactionType,
  this.repeatMode,this.repeatEvery,this.repeatCount,this.date,
  this.dateFinish,this.monday,this.tuesday,this.wednesday,this.thursday,this.friday,this.saturday,this.sunday});

  Map<String, dynamic> toMap({ignoreId=false}) {
    Map<String, dynamic> map = {
      'id': id,
      'id_user': idUser,
      'id_account': idAccount,
      'id_account_transfer': idAccountTransfer,
      'amount':amount,
      'notes':notes,
      'transaction_mode':(){
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
      'date':DateFormat('yyyy-MM-dd').format(date),
      'date_finish':DateFormat('yyyy-MM-dd').format(dateFinish),
      'monday':this.monday?1:0,
      'tuesday':this.tuesday?1:0,
      'wednesday':this.wednesday?1:0,
      'thursday':this.thursday?1:0,
      'friday':this.friday?1:0,
      'saturday':this.saturday?1:0,
      'sunday':this.sunday?1:0,
    };
    if(ignoreId)map.remove('id');
    return map;
  }

  static Transaction fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      idUser: map['id_user'],
      idAccount: map['id_account'],
      idAccountTransfer: map['id_account_transfer'],
      amount: map['amount'],
      notes: map['notes'],
      transactionType:(){
        switch (map['transaction_type']) {
          case 'I': return TransactionType.Income;
          case 'e': return TransactionType.Expense;
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
      dateFinish: DateFormat('yyyy-MM-dd').parse(map['date_finish']),
      monday: map['monday']=='1',
      tuesday: map['tuesday']=='1',
      wednesday: map['wednesday']=='1',
      thursday: map['thursday']=='1',
      friday: map['friday']=='1',
      saturday: map['saturday']=='1',
      sunday: map['sunday']=='1',
    );
  }

  static Future<int> add(Transaction transaction){
    final db=DB.db;
    return db.insert(tableName,transaction.toMap(ignoreId: true));
  }

  static Future<int> editById(Transaction transaction,int id){
    final db=DB.db;

    return db.update(Transaction.tableName,transaction.toMap(ignoreId: true),
      where: 'id = ?',whereArgs: [id]
    );
  }

  static Future<List<Transaction>> getAll({String orderBy='id asc'})async{
    final  db=DB.db;

    return db.query(Transaction.tableName,orderBy: orderBy)
      .then((res){
        if(res.length>0){
          return res.map((v)=>Transaction.fromMap(v)).toList();
        }
        else return [];
      });
  }

  static Future<List<Transaction>> getPaginated({String orderBy='id asc'})async{
    final  db=DB.db;

    return db.query(Transaction.tableName,orderBy: orderBy)
      .then((res){
        if(res.length>0){
          return res.map((v)=>Transaction.fromMap(v)).toList();
        }
        else return [];
      });
  }

  static Future<Transaction> getById(int id)async{
    final  db=DB.db;

    return db.query(Transaction.tableName,where: 'id = ?',whereArgs: [id])
      .then((res){
        if(res.length>0)return Transaction.fromMap(res[0]);
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