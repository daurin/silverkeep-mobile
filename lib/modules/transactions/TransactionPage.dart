import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:silverkeep/db/models/Account.dart';
import 'package:silverkeep/db/models/Transaction.dart';
import 'package:silverkeep/modules/accounts/AccountSearchDialog.dart';
import 'package:silverkeep/modules/shared/colors/ColorsApp.dart';
import 'package:silverkeep/modules/transactions/CustomNotificationPage.dart';

class TransactionPage extends StatefulWidget {

  final int id;
  final TransactionType transactionType;

  TransactionPage({Key key,this.id,this.transactionType}) : super(key: key);

  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  Transaction _transaction;
  Account _account;
  Account _accountTransfer;

  @override
  void initState() {
    super.initState();

    _transaction=Transaction(
      transactionType: widget.transactionType,
      date: DateTime.now(),
      repeatMode: 'not'
    );

    _account=Account(
      color: 'predeterminated'
    );

    _accountTransfer=null;

    Account.getFirst()
      .then((Account account){
        if(account!=null){
          print(account.color);
          setState(() {
            _account=account;
          });
        }
      });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text((){
          switch (_transaction.transactionType) {
            case TransactionType.Income: return 'Nuevo Ingreso';
            case TransactionType.Expense: return 'Nuevo Gasto';
            case TransactionType.Transfer: return 'Nueva Transacción';
            default: return '';
          }
        }()),
        actions: <Widget>[
          FlatButton(
            child: Text('Guardar'),
            textColor: Theme.of(context).primaryTextTheme.title.color,
            onPressed: _save
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title:TextField(
              style: Theme.of(context).textTheme.headline,
              keyboardType: TextInputType.numberWithOptions(signed: true,decimal: true),
              autofocus: true,
              decoration: InputDecoration.collapsed(
                hintText: 'Monto',
                border: InputBorder.none,
                hintStyle: Theme.of(context).textTheme.headline.copyWith(color:Theme.of(context).hintColor)
              ),
              inputFormatters: [
                ThousandsFormatter(allowFraction: true)
              ],
            )
          ),
          Divider(),
          ListTile(
            leading: Icon(MdiIcons.walletOutline,
            color: _account?.color==null?Colors.grey:ColorsApp(context).getColorDataByKey(_account.color)['color'],),
            title: Text(_account?.name??''),
            trailing: _transaction.transactionType==TransactionType.Transfer?Icon(MdiIcons.bankTransferOut,color: Colors.red):null,
            onTap: _onTabAccount,
          ),
          Visibility(
            visible: _transaction.transactionType==TransactionType.Transfer,
            child: ListTile(
              leading: Icon(MdiIcons.walletOutline,
                color: _accountTransfer?.color==null?Colors.grey:ColorsApp(context).getColorDataByKey(_accountTransfer?.color)['color'],),
              title: Text(_accountTransfer?.name??''),
              trailing: Icon(MdiIcons.bankTransferIn,color: Colors.green),
              onTap: _onTabAccountTransfer,
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.date_range),
            title: Text(DateFormat.yMMMMEEEEd().format(_transaction.date)),
            onTap: _onTabDate,
          ),
          ListTile(
            leading: Icon(Icons.repeat),
            title: Text(_transaction.repeatMode),
            onTap: _onTabRepeat,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.notifications_none),
            title: Text('Notificacion'),
            onTap: _onTabNotification,
          ),
          Visibility(visible: _transaction.transactionType==TransactionType.Transfer,child: Divider()),
          Visibility(
            visible: _transaction.transactionType!=TransactionType.Transfer,
            child: ListTile(
              leading: Icon(Icons.label_outline),
              title: Wrap(
                spacing: 10,
                children: <Widget>[
                  Chip(
                    label: Text('Entretenimiento'),
                    backgroundColor: Colors.transparent,
                    shape: StadiumBorder(side: BorderSide(color: Colors.grey)),
                  ),
                  Chip(
                    label: Text('Sueldo'),
                    backgroundColor: Colors.transparent,
                    shape: StadiumBorder(side: BorderSide(color: Colors.grey)),
                  ),
                ],
              ),
              //isThreeLine: true,
              onTap: _onTabLabels,
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.subject),
            title: TextField(
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration.collapsed(
                hintText: 'Notas',
              ),
            ),
          ),
          SizedBox(
            height: 150,
          )
        ],
      ),
      bottomNavigationBar: Container(
        height: kBottomNavigationBarHeight,
        child: RaisedButton(
          child: Text('Guardar',style: TextStyle(fontSize: 16),),
          textColor: Theme.of(context).primaryTextTheme.title.color,
          onPressed: _save
        ),
      )
    );
  }

  void _onTabAccount(){
    showDialog<Account>(
      context: context,
      builder: (context){
        return AccountSearchDialog();
      }
    )
    .then((Account account){
      if(account!=null){
        setState(() {
          if(account?.id==_accountTransfer?.id){
            _accountTransfer=null;
          }
          _account=account;
        });
      }
    });
  }

  void _onTabAccountTransfer(){
    showDialog<Account>(
      context: context,
      builder: (context){
        return AccountSearchDialog();
      }
    )
    .then((Account account){
      if(account!=null){
        setState(() {
          if(account?.id==_account?.id){
            _account=null;
          }
          _accountTransfer=account;
        });
      }
    });
  }

  void _onTabDate(){
    showDatePicker(
      context: context,
      initialDate: _transaction.date,
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(Duration(days: 36500))
    )
    .then((DateTime date){
      if(date!=null){
        setState(() {
          _transaction.date=date;
        });
      }
    });
  }

  void _onTabRepeat(){
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                {
                  'value':'not',
                  'title':'No se repite',
                },
                {
                  'value':'everyday',
                  'title':'Todos los dias',
                },
                {
                  'value':'everyweek',
                  'title':'Todas las semanas',
                },
                {
                  'value':'everymonth',
                  'title':'Todos los meses',
                },
                {
                  'value':'everyyear',
                  'title':'Todos los años',
                },
                {
                  'value':'custom',
                  'title':'Personalizacion',
                },
              ].map((v){
                return RadioListTile<String>(
                  value: v['value'],
                  groupValue: _transaction.repeatMode,
                  onChanged: (String value){
                    if(value=='custom'){
                      Navigator.pushReplacement(context,MaterialPageRoute(
                        builder: (BuildContext context) => CustomNotificationPage()
                      ));
                    }
                    else{
                      setState(() {
                        _transaction.repeatMode=value;
                      });
                      Navigator.pop(context);
                    }
                  },
                  title: Text(v['title']),
                );
              }).toList()
            ),
          ),
        );
      }
    );
  }

  void _onTabNotification(){

  }

  void _onTabLabels(){

  }

  _save(){
    return;
    Transaction.add(_transaction)
      .then((v){
        Navigator.pop(context);
      });

    // switch (_transaction.transactionType) {
    //   case TransactionType.Income:
    //     Transaction.add(_transaction);
    //     break;
    //   case TransactionType.Expense:
    //     Transaction.add(_transaction);
    //     break;
    //   case TransactionType.Transfer:
    //     Transaction.add(_transaction);
    //     break;
    //   default:
    //     return;
    // }
  }
}