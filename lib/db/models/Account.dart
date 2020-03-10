import '../DB.dart';

class Account {

  int id;
  int idUser;
  String name;
  String color;
  int orderCustom;

  static String tableName = 'ACCOUNT';

  Account({this.id, this.idUser, this.name, this.color,this.orderCustom});

  Map<String, dynamic> toMap({ignoreId=false}) {
    Map<String, dynamic> map = {
      'id': id,
      'id_user': idUser,
      'name': name,
      'color': color,
      'order_custom':orderCustom
    };
    if(ignoreId)map.remove('id');
    return map;
  }

  static Account fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id'],
      idUser: map['id_user'],
      name: map['name'],
      color: map['color'],
      orderCustom: map['order_custom']
    );
  }

  static Future<int> add(Account account){
    final db=DB.db;

    return db.insert(tableName,
    {
      'id_user':account.idUser,
      'name':account.name,
      'color':account.color,
      'order_custom':account.orderCustom
    });
  }

  static Future<int> editById(Account account,int id){
    final db=DB.db;

    return db.update(Account.tableName,
      {
        'name':account.name,
        'color':account.color,
        'order_custom':account.orderCustom
      },
      where: 'id = ?',whereArgs: [id]
    );
  }

  static Future<Account> getFirst()async{
    final  db=DB.db;

    return db.query(Account.tableName,limit: 1,orderBy: 'order_custom asc')
      .then((res){
        if(res.length>0){
          return Account.fromMap(res[0]);
          //return res.map((v)=>Account.fromMap(v)).toList();
        }
        else return null;
      });
  }

  static Future<List<Account>> getAll({String orderBy='order_custom,id asc'})async{
    final  db=DB.db;

    return db.query(Account.tableName,orderBy: orderBy)
      .then((res){
        if(res.length>0){
          return res.map((v)=>Account.fromMap(v)).toList();
        }
        else return [];
      });
  }

  static Future<Account> getById(int id)async{
    final  db=DB.db;

    return db.query(Account.tableName,where: 'id = ?',whereArgs: [id])
      .then((res){
        if(res.length>0)return Account.fromMap(res[0]);
        else return null;
      });
  }

  // static Future<int> getLastOrderCustom(){
  //   final  db=DB.db;

  //   db.rawQuery('SELECT ifnull(max(order_custom),0) as value FROM ACCOUNT')
  //     .then((res){
  //       if(res.length>0)return res[0];
  //       else return null;
  //     });
  // }

  static Future<void> deleteById(int id)async{
    final  db=DB.db;
    return db.delete(Account.tableName,where: 'id = ?',whereArgs: [id]);
  }

}
