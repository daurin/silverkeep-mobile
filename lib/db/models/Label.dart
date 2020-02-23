import '../DB.dart';

class Label {

  int id;
  String name;
  String type;
  String color;
  int orderCustom;

  static String tableName = 'LABEL';

  Label({this.id, this.name, this.type,this.color,this.orderCustom});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'id': id,
      'name': name,
      'type': type,
      'color':color,
      'order_custom':orderCustom
    };
    return map;
  }

  static Label fromMap(Map<String, dynamic> map) {
    return Label(
        id: map['id'],
        name: map['name'],
        type: map['type'],
        color: map['color']);
  }

  static Future<int> add(Label label){
    final db=DB.db;

    return db.insert(tableName,
    {
      'name':label.name,
      'type':label.type,
      'color':label.color,
      'order_custom':label.orderCustom
    });
  }

  static Future<int> editById(Label label,int id){
    final db=DB.db;

    return db.update(Label.tableName,
      {
        'name':label.name,
        'type':label.type,
        'color':label.color,
        'order_custom':label.orderCustom
      },
      where: 'id = ?',whereArgs: [id]
    );
  }

  static Future<List<Label>> getAll()async{
    final  db=DB.db;

    return db.query(Label.tableName)
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

  static Future<Label> getById(int id)async{
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
}
