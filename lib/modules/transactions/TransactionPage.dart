import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:silverkeep/db/models/Account.dart';
import 'package:silverkeep/db/models/Label.dart';
import 'package:silverkeep/db/models/Transaction.dart';
import 'package:silverkeep/modules/accounts/AccountSearchDialog.dart';
import 'package:silverkeep/modules/shared/colors/ColorsApp.dart';
import 'package:silverkeep/modules/transactions/CustomNotificationPage.dart';

import 'TransactionLabelsPage.dart';

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

  TextEditingController _amountController,_descriptionController,_notesController;

  @override
  void initState() {
    super.initState();

    _transaction=Transaction(
      transactionType: widget.transactionType,
      date: DateTime.now(),
      repeatMode: TransactionRepeatMode.NotRepeat,
      repeatCount: 1,
      repeatEvery: TransactionRepeatEvery.Days,
      notifyTimeType: NotifyTimeType.Minutes,
      notifyTimes: 10,
      labels: []
    );

    _amountController=TextEditingController();
    _descriptionController=TextEditingController();
    _notesController=TextEditingController();


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
            _transaction.idAccount=account.id;
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
          ButtonBar(
            children: <Widget>[
              FlatButton(
                child: Text('Guardar'),
                textTheme: ButtonTextTheme.accent,
                onPressed: _save
              )
            ],
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title:TextField(
              controller: _amountController,
              style: Theme.of(context).textTheme.headline,
              keyboardType: TextInputType.numberWithOptions(signed: true,decimal: true),
              textInputAction: TextInputAction.done,
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
            leading: Icon(MdiIcons.textShort),
            title: TextField(
              controller: _descriptionController,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration.collapsed(
                hintText: 'Descripcion'
              ),
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
            title: Text(_getTitleRepeat(_transaction.repeatMode,repeatCount: _transaction.repeatCount)),
            subtitle: Text('Recurrencia'),
            onTap: _onTabRepeat,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.notifications_none),
            title: Text((){
              switch (_transaction.notifyTimeType) {
                case NotifyTimeType.Minutes: return '${_transaction.notifyTimes} minutos antes';
                case NotifyTimeType.Hours: return '${_transaction.notifyTimes} horas antes';
                case NotifyTimeType.Days: return '${_transaction.notifyTimes} dias antes';
                case NotifyTimeType.Weeks: return '${_transaction.notifyTimes} semanas antes';
                default: return 'Sin notificación';
              }
            }()),
            subtitle: Text('Notificacion'),
            onTap: _onTabNotification,
          ),
          Visibility(visible: _transaction.transactionType!=TransactionType.Transfer,child: Divider()),
          Visibility(
            visible: _transaction.transactionType!=TransactionType.Transfer,
            child: ListTile(
              leading: Icon(Icons.label_outline),
              title: _transaction.labels.length>0?Wrap(
                spacing: 10,
                runSpacing: -5,
                runAlignment: WrapAlignment.start,
                alignment: WrapAlignment.start,
                children: _transaction.labels.map((Label label){
                  return Chip(
                    label: Text(label.name,
                      style: TextStyle(color: ColorsApp(context).getColorDataByKey(label.color)['color']),
                    ),
                    //backgroundColor: ColorsApp(context).getColorDataByKey(label.color)['color'],
                  );
                }).toList(),
              ):Text('Etiquetas',style: TextStyle(color: Theme.of(context).hintColor),),
              onTap: _onTabLabels,
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.subject),
            title: TextField(
              controller: _notesController,
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
      // bottomNavigationBar: Container(
      //   height: kBottomNavigationBarHeight,
      //   child: RaisedButton(
      //     child: Text('Guardar',style: TextStyle(fontSize: 16),),
      //     textColor: Theme.of(context).primaryTextTheme.title.color,
      //     onPressed: _save
      //   ),
      // )
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
          _transaction.idAccount=account.id;
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
          _transaction.idAccountTransfer=account.id;
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

  _getTitleRepeat(TransactionRepeatMode repeatMode,{int repeatCount}){
    switch (repeatMode) {
      case TransactionRepeatMode.NotRepeat: return 'No se repite';
      case TransactionRepeatMode.EveryDay: return 'Todos los dias';
      case TransactionRepeatMode.EveryWeek: return 'Todas las semanas';
      case TransactionRepeatMode.EveryMonth: return 'No se Todos los meses';
      case TransactionRepeatMode.EveryYear: return 'Todos los años';
      case TransactionRepeatMode.Custom:
        String label='Se repite ';
        if(_transaction.repeatEvery==TransactionRepeatEvery.Days)label+='cada ${_transaction.repeatCount} dias';
        if(_transaction.repeatEvery==TransactionRepeatEvery.Weeks)label+='cada ${_transaction.repeatCount} semanas';
        if(_transaction.repeatEvery==TransactionRepeatEvery.Months)label+='cada ${_transaction.repeatCount} meses';
        if(_transaction.repeatEvery==TransactionRepeatEvery.Years)label+='cada ${_transaction.repeatCount} años';
        return label;
      default: return 'Todos los dias';
    }
  }
  void _onTabRepeat(){
    showDialog(
      context: context,
      builder: (context){
        List<Map<String,dynamic>> items=[];
        if(_transaction.repeatMode==TransactionRepeatMode.Custom) {
          items.add(
            {
              'value':TransactionRepeatMode.Custom,
              'label':_getTitleRepeat(TransactionRepeatMode.Custom,repeatCount: _transaction.repeatCount)
            }
          );
        }

        items.addAll([
          {
            'value':TransactionRepeatMode.NotRepeat,
            'label':_getTitleRepeat(TransactionRepeatMode.NotRepeat),
          },
          {
            'value':TransactionRepeatMode.EveryDay,
            'label':_getTitleRepeat(TransactionRepeatMode.EveryDay),
          },
          {
            'value':TransactionRepeatMode.EveryWeek,
            'label':_getTitleRepeat(TransactionRepeatMode.EveryWeek),
          },
          {
            'value':TransactionRepeatMode.EveryMonth,
            'label':_getTitleRepeat(TransactionRepeatMode.EveryMonth),
          },
          {
            'value':TransactionRepeatMode.EveryYear,
            'label':_getTitleRepeat(TransactionRepeatMode.EveryYear),
          },
          {
            'value':null,
            'label':'Personalizado',
          },
        ]);

        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: items.map((v){
                return GestureDetector(
                  child: RadioListTile<TransactionRepeatMode>(
                    value: v['value'],
                    groupValue: _transaction.repeatMode,
                    onChanged: (TransactionRepeatMode value){
                      if(value==null){
                        Navigator.pushReplacement(context,MaterialPageRoute(
                          builder: (BuildContext context) => CustomNotificationPage(
                            transaction: _transaction,
                          )
                        ))
                          .then((value){
                            if(value!=null){
                              setState(() {
                                _transaction=value;
                              });
                            }
                          });
                      }
                      else{
                        setState(() {
                          _transaction.repeatMode=value;
                        });
                        Navigator.pop(context);
                      }
                    },
                    title: Text(v['label']),
                  ),
                );
              }).toList()
            ),
          ),
        );
      }
    );
  }

  void _onTabNotification(){
    showDialog(
      context: context,
      builder: (BuildContext context){
        TextEditingController textController=TextEditingController(
          text: _transaction.notifyTimes.toInt().toString()
        );
        FocusNode focusNode=FocusNode();
        focusNode.addListener((){
          if(focusNode.hasFocus)
            textController.selection=TextSelection(baseOffset: 0, extentOffset: textController.text.length);
        });

        bool textEnabled=_transaction.notifyTimeType!=null;
        NotifyTimeType notifyTimeType=_transaction.notifyTimeType;

        return StatefulBuilder(builder: (context,setStateDialog){
          return AlertDialog(
            contentPadding: EdgeInsets.symmetric(vertical: 20,horizontal: 0),
            title: Text('Notificación'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: TextField(
                      controller: textController,
                      focusNode: focusNode,
                      keyboardType: TextInputType.numberWithOptions(signed: false,decimal: false),
                      enabled: textEnabled,
                      decoration: InputDecoration.collapsed(
                        hintText: '',
                        border: UnderlineInputBorder()
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter((){
                          switch (notifyTimeType) {
                            case NotifyTimeType.Minutes:
                            case NotifyTimeType.Hours:
                              return 3;
                            case NotifyTimeType.Days:return 2;
                            case NotifyTimeType.Weeks:default:return 1;
                          }
                        }()),
                        WhitelistingTextInputFormatter.digitsOnly,
                        TextInputFormatter.withFunction((TextEditingValue oldValue, TextEditingValue newValue){
                          if(newValue.text.length==0)return newValue;
                          if(newValue.text[0]=='0')return newValue.copyWith(text: '1');
                          
                          int newNum=int.parse(newValue.text);
                          switch (notifyTimeType) {
                            case NotifyTimeType.Minutes: return newNum>600 ? newValue.copyWith(text: '600'):newValue;
                            case NotifyTimeType.Hours: return newNum>120 ? newValue.copyWith(text: '120'):newValue;
                            case NotifyTimeType.Days: return newNum>28 ? newValue.copyWith(text: '28'):newValue;
                            case NotifyTimeType.Weeks: return newNum>4 ? newValue.copyWith(text: '4'):newValue;
                            default:return newValue;
                          }
                        })
                      ],
                    ),
                  ),
                  SizedBox(height: 13),
                  ...[
                      {
                        'value':null,
                        'label':'Sin notificación',
                      },
                      {
                        'value':NotifyTimeType.Minutes,
                        'label':'Minutos antes',
                      },
                      {
                        'value':NotifyTimeType.Hours,
                        'label':'Horas antes',
                      },
                      {
                        'value':NotifyTimeType.Days,
                        'label':'Dias antes',
                      },
                      {
                        'value':NotifyTimeType.Weeks,
                        'label':'Semanas antes',
                      },
                  ].map((v){
                    return RadioListTile<NotifyTimeType>(
                      value: v['value'],
                      groupValue: notifyTimeType,
                      onChanged: (NotifyTimeType value){
                        setStateDialog(() {
                          notifyTimeType=value;
                          textEnabled=value!=null;
                        });

                        int number=int.parse(textController.text.length==0?'1':textController.text);
                        switch (notifyTimeType) {
                          case NotifyTimeType.Hours:
                            if(number>120) textController.text='120';
                            break;
                          case NotifyTimeType.Days:
                            if(number>28)textController.text='28';
                            break;
                          case NotifyTimeType.Weeks:
                            if(number>4)textController.text='4';
                            break;
                          case NotifyTimeType.Minutes: default: break;
                        }
                      },
                      title: Text(v['label']),
                    );
                  }).toList()
                ]
              ),
            ),
            actions: <Widget>[
              ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child: Text('Listo'),
                    onPressed: (){
                      setState(() {
                        _transaction.notifyTimes=int.parse(textController.text.length==0?'1':textController.text);
                        _transaction.notifyTimeType=notifyTimeType;
                      });
                      Navigator.pop(context);
                    },
                  )
                ],
              )
            ],
          );
        });
      }
    );
  }

  void _onTabLabels(){
    Navigator.push<List<Label>>(context, MaterialPageRoute(builder: (context)=>TransactionLabelsPage(
      //transactionId: _transaction.id,
      transactionType: _transaction.id ==null?_transaction.transactionType:null,
      initialLabelsSelected: _transaction.labels,
    )))
      .then((List<Label> labels){
        setState(() {
          _transaction.labels=labels;
        });
      });
  }

  _save(){
    _transaction.amount=double.parse(_amountController.text.replaceAll(',', '')??'0');
    _transaction.description=_descriptionController.text;
    _transaction.notes=_notesController.text;

    Transaction.add(_transaction)
      .then((v){
        Navigator.pop(context);
      })
      .catchError((error){
        print(error);
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