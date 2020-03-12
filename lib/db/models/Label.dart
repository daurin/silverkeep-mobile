import 'package:meta/meta.dart';
import '../DB.dart';

class Label {

  int id;
  String name;
  LabelType type;
  String color;
  int orderCustom;

  static String tableName = 'LABEL';

  Label({this.id, this.name, this.type,this.color='predeterminated',this.orderCustom});

  Map<String, dynamic> toMap({ignoreId=false}) {
    Map<String, dynamic> map = {
      'id': id,
      'name': name,
      'type': (){
        switch (type) {
          case LabelType.Expense:return 'E';
          case LabelType.Income:return 'I';
          default: return null;
        }
      }(),
      'color':color,
      'order_custom':orderCustom
    };
    if(ignoreId)map.remove('id');

    return map;
  }

  static Label fromMap(Map<String, dynamic> map) {
    return Label(
        id: map['id'],
        name: map['name'],
        type: (){
          switch (map['type']) {
            case 'E':return LabelType.Expense;
            case 'I':return LabelType.Income;
            default: return null;
          }
        }(),
        color: map['color']);
  }

  static Future<int> add(Label label){
    final db=DB.db;

    return db.insert(tableName,
    label.toMap(ignoreId: true));
  }

  static Future<int> editById(Label label,int id){
    final db=DB.db;

    return db.update(Label.tableName,
      label.toMap(),
      where: 'id = ?',whereArgs: [id]
    );
  }

  static Future<List<Label>> select({LabelType type})async{
    final  db=DB.db;

    List<String> where=[];
    List<String> whereArgs=[];

    if(type==LabelType.Income){
      where.add('type= ?');
      whereArgs.add('I');
    }
    if(type==LabelType.Expense){
      where.add('type= ?');
      whereArgs.add('E');
    }

    return db.query(Label.tableName,where: where.join(' AND '),whereArgs: whereArgs)
      .then((res){
        if(res.length>0){
      
          return res.map((v)=>Label.fromMap(v)).toList();
        }
        else return [];
      });
  }

  static Future<List<Label>> getAllIncomes({String orderBy='id asc'})async{
    final  db=DB.db;

    return db.query(Label.tableName,where: 'type = ?',whereArgs: ['I'],orderBy: orderBy)
      .then((res){
        if(res.length>0){
          return res.map((v)=>Label.fromMap(v)).toList();
        }
        else return [];
      });
  }

  static Future<List<Label>> getAllExpense({String orderBy='id asc'})async{
    final  db=DB.db;

    return db.query(Label.tableName,where: 'type = ?',whereArgs: ['E'],orderBy: orderBy)
      .then((res){
        if(res.length>0){
          return res.map((v)=>Label.fromMap(v)).toList();
        }
        else return [];
      });
  }

  static Future<Label> findById(int id)async{
    final  db=DB.db;

    return db.query(Label.tableName,where: 'id = ?',whereArgs: [id])
      .then((res){
        if(res.length>0)return Label.fromMap(res[0]);
        else return null;
      });
  }

  static Future<void> deleteById(int id)async{
    final  db=DB.db;
    return db.delete(Label.tableName,where: 'id = ?',whereArgs: [id]);
  }

  static Future<bool> existByField({@required String field,@required String value,LabelType type})async{
    final db=DB.db;

    String query='SELECT 1 FROM ${Label.tableName} WHERE $field=?';

    if(type==LabelType.Income)query+=" AND type='I'";
    if(type==LabelType.Expense)query+=" AND type='E'";

    query+=' COLLATE NOCASE';

    query='SELECT EXISTS ($query)as exist;';
    return await db.rawQuery(query,[value])
      .then((res){
        print(res.first['exist']);
        return Future.value(res.first['exist'].toString()=='1');
      });
  }
}

enum LabelType{
  Income,
  Expense
}