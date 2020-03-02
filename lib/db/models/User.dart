import '../DB.dart';
import 'Model.dart';

class User {
  int id;
  String firstName;
  String lastName;
  String email;
  String password;

  static String tableName = 'USER';

  User({this.id,this.firstName,this.lastName,this.email,this.password});

  Map<String,dynamic> toMap({ignoreId = false}) {
    Map<String, dynamic> map = {
      'id': id,
      'first_name':firstName,
      'last_name':lastName,
      'email':email,
      'password':password
    };
    if(ignoreId)map.remove('id');
    return map;
  }

  static Future<int> add(User user){
    final db=DB.db;
    return db.insert(tableName,user.toMap(ignoreId: true));
  }
}