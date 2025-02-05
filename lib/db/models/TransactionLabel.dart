import 'package:meta/meta.dart';
import '../DB.dart';

class TransactionLabel {

  int idTransaction;
  int idLabel;
  

  static String tableName = 'Transaction_LABEL';

  TransactionLabel({@required this.idTransaction,@required this.idLabel});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'id_transaction': idTransaction,
      'id_label': idLabel,
    };

    return map;
  }

  static TransactionLabel fromMap(Map<String, dynamic> map) {
    return TransactionLabel(
      idTransaction: map['id_transaction'],
      idLabel: map['id_t=label'],
    );
  }

  static Future<int> add(TransactionLabel label){
    final db=DB.db;

    return db.insert(tableName,label.toMap());
  }

  static Future<void> deleteByIds({int idTransaction,int idLabel})async{
    final  db=DB.db;
    List<String> where=[];
    List<int> whereArgs=[];
    if(idTransaction!=null){
      where.add('id_transaction = ?');
      whereArgs.add(idTransaction);
    }
    if(idLabel!=null){
      where.add('id_label = ?');
      whereArgs.add(idLabel);
    }

    return await db.delete(TransactionLabel.tableName,where: where.join(' AND '),whereArgs: whereArgs);
  }
}