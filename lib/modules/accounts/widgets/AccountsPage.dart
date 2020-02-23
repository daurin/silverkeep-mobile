import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:reorderables/reorderables.dart';
import 'package:silverkeep/db/models/Account.dart';
import 'package:silverkeep/modules/shared/colors/ColorsApp.dart';
import 'package:silverkeep/services/SharedPrefService.dart';
import 'AccountPage.dart';

class AccountsPage extends StatefulWidget {
  AccountsPage({Key key}) : super(key: key);

  @override
  _AccountsPageState createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {

  SharedPrefService _prefService;
  List<Account> _accounts;

  @override
  void initState() {
    super.initState();

    _prefService=SharedPrefService();
    _loadAccounts();
      }
    
    
      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title:Text('Cuentas'),
            actions: <Widget>[
              IconButton(
                icon: Icon(_prefService.showAccountAmount?MdiIcons.eyeOutline:MdiIcons.eyeOffOutline),
                onPressed: (){
                  setState(() {
                    _prefService.showAccountAmount=!_prefService.showAccountAmount;
                  });
                },
              )
            ],
          ),
          body: Builder(
            builder: (BuildContext bc){
              if(_accounts==null)return Container();
              if(_accounts.length==0){
                return Center(
                  child: Text('No hay cuentas'),
                );
              }

              return ReorderableColumn(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _accounts.map((v){
                  return _buildAccountItem(
                    id: v.id,
                    name: v.name,
                    color:v.color
                  );
                }).toList(),
                onReorder: _onReorder
              );

              // return ListView.separated(
              //   itemCount: _accounts.length,
              //   itemBuilder: (BuildContext context,int i){
              //     return _buildAccountItem(
              //       id: _accounts[i].id,
              //       name: _accounts[i].name,
              //       color:_accounts[i].color
              //     );
              //   },
              //   separatorBuilder:(BuildContext context,int index)=> Divider(height: 1,),
              // );
            }
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccountPage()),
              )
              .then((res){
                if(res)_loadAccounts();
              });
            }
          ),
        );
      }

      void _loadAccounts() {
        Account.getAll()
        .then((res){
          setState(() {
            _accounts=res;
          });
        });
      }

      void _onReorder(int oldIndex, int newIndex)async{
        setState((){
          Account row = _accounts.removeAt(oldIndex);
          _accounts.insert(newIndex, row);
        });
        for (int i = 0; i < _accounts.length; i++) {
          _accounts[i].orderCustom=i; 
          await Account.editById(_accounts[i],_accounts[i].id);
        }
      }
    
      Widget _buildAccountItem({int id,String name,String color}){
        return ListTile(
          key: ValueKey(id),
          leading: CircleAvatar(
            child: Text(name.substring(0,1),),
            backgroundColor: ColorsApp(context).getColorDataByKey(color)['color'],
            //foregroundColor: color,
          ),
          title: Text(name),
          trailing: _prefService.showAccountAmount?
            Text('\$0',style: TextStyle(fontSize: 16,color:Colors.green[400]),):
            Container(width: 50,height: 15,color: Colors.grey.shade400),
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AccountPage(idAccount: id,)),
            )
            .then((res){
              if(res)_loadAccounts();
            });
          },
        );
      }
}