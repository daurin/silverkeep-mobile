import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:reorderables/reorderables.dart';
import 'package:silverkeep/blocs/transaction/TransactionBloc.dart';
import 'package:silverkeep/blocs/transaction/TransactionEvents.dart';
import 'package:silverkeep/blocs/transaction/TransactionState.dart';
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
  List<Account> _accounts;

  @override
  void initState() {
    super.initState();

    _loadAccounts();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc,TransactionState>(
      condition: (previusState,state){
        return previusState.visibleAmount!=state.visibleAmount;
      },
      builder: (context,state){
        return Scaffold(
          appBar: AppBar(
            title: Text('Cuentas'),
            actions: <Widget>[
              ButtonBar(
                children: <Widget>[
                  IconButton(
                    icon: Icon(state.visibleAmount
                        ? MdiIcons.eyeOutline
                        : MdiIcons.eyeOffOutline),
                    onPressed: () {
                      BlocProvider.of<TransactionBloc>(context).add(ChangeVisibleAmount(!state.visibleAmount));
                    },
                  )
                ],
              )
            ],
          ),
          body: Builder(builder: (BuildContext bc) {
            if (_accounts == null) return Container();
            if (_accounts.length == 0) {
              return Center(
                child: Text('No hay cuentas'),
              );
            }
            return ReorderableColumn(
                crossAxisAlignment: CrossAxisAlignment.start,
                needsLongPressDraggable: true,
                children: _accounts.map((v) {
                  return _buildAccountItem(id: v.id, name: v.name, color: v.color,visibleAmount: state.visibleAmount);
                }).toList(),
                onReorder: _onReorder);
          }),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccountPage()),
              ).then((res) {
                if (res) _loadAccounts();
              });
            }
          ),
        );
      },
    );
  }

  void _loadAccounts() {
    Account.getAll().then((res) {
      setState(() {
        _accounts = res;
      });
    });
  }

  void _onReorder(int oldIndex, int newIndex) async {
    setState(() {
      Account row = _accounts.removeAt(oldIndex);
      _accounts.insert(newIndex, row);
    });
    for (int i = 0; i < _accounts.length; i++) {
      _accounts[i].orderCustom = i;
      await Account.editById(_accounts[i], _accounts[i].id);
    }
  }

  Widget _buildAccountItem({int id, String name, String color,bool visibleAmount}) {
    return ListTile(
      key: ValueKey(id),
      leading: CircleAvatar(
        child: Text(
          name.substring(0, 1),
        ),
        backgroundColor: ColorsApp(context).getColorDataByKey(color)['color'],
        //foregroundColor: color,
      ),
      title: Text(name),
      trailing: visibleAmount
          ? Text(
              '\$0',
              style: TextStyle(fontSize: 16, color: Colors.green[400]),
            )
          : Container(width: 50, height: 15, color: Colors.grey.shade400),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AccountPage(
                    idAccount: id,
                  )),
        ).then((res) {
          if (res) _loadAccounts();
        });
      },
    );
  }
}
