import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:silverkeep/blocs/transaction/TransactionBloc.dart';
import 'package:silverkeep/blocs/transaction/TransactionEvents.dart';
import 'package:silverkeep/db/models/Account.dart';
import 'package:silverkeep/db/models/Label.dart';
import 'package:silverkeep/db/models/Transaction.dart';
import 'package:silverkeep/enums/PageMode.dart';
import 'package:silverkeep/modules/accounts/AccountSearchDialog.dart';
import 'package:silverkeep/modules/shared/colors/ColorsApp.dart';
import 'package:silverkeep/modules/transactions/CustomRepeatPage.dart';
import 'package:silverkeep/utils/IsNumeric.dart';

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
  // Account _account;
  // Account _accountTransfer;

  TextEditingController _amountController,_descriptionController,_notesController;
  TransactionBloc _transactionBloc;
  PageMode _pageMode;


  @override
  void initState() {
    super.initState();

    _amountController=TextEditingController();
    _descriptionController=TextEditingController();
    _notesController=TextEditingController();
    _transactionBloc = BlocProvider.of<TransactionBloc>(context);

    if(widget.id==null){
      _pageMode=PageMode.add;
      _transaction=Transaction(
        amount: 0,
        description: '',
        transactionType: widget.transactionType,
        date: DateTime.now(),
        repeatMode: TransactionRepeatMode.NotRepeat,
        repeatEvery: TransactionRepeatEvery.Days,
        repeatEveryCount: 1,
        notifyTimeType: NotifyTimeType.NotNotify,
        notifyTimes: 10,
        labels: [],
        finishRepeatMode: TransactionFinishMode.Date,
      );
      _transaction.account=Account(
        color: 'predeterminated'
      );
      _transaction.accountTransfer=null;

      Account.getFirst()
        .then((Account account){
          if(account!=null){
            setState(() {
              _transaction.account=account;
            });
          }
        });
    }
    else{
      _pageMode=PageMode.edit;

      WidgetsBinding.instance
      .addPostFrameCallback((_)async{
        Transaction transaction=await Transaction.findById(widget.id);
        setState(() {
          _transaction=transaction;
        });
        _amountController.text= NumberFormat.decimalPattern().format(transaction.amount);
        _descriptionController.text=transaction.description;
        _notesController.text=transaction.notes;
      });
    }

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text((){
          if(_pageMode==PageMode.add){
            switch (_transaction?.transactionType) {
              case TransactionType.Income: return 'Nuevo Ingreso';
              case TransactionType.Expense: return 'Nuevo Gasto';
              case TransactionType.Transfer: return 'Nueva Transacción';
              default: return '';
            }
          }
          else return _transaction?.description??'';
        }()),
        actions: <Widget>[
          ButtonBar(
            children: <Widget>[
              Visibility(
                visible: _pageMode==PageMode.edit,
                child: IconButton(
                  icon: Icon(Icons.delete_outline),
                  color: Colors.red,
                  onPressed: _delete
                ),
              ),
              FlatButton(
                child: Text('Guardar'),
                textTheme: ButtonTextTheme.accent,
                onPressed: _save
              )
            ],
          )
        ],
      ),
      body: Builder(
        builder: (context) {
          if(_transaction==null)return Container();

          return ListView(
            children: <Widget>[
              ListTile(
                title:TextField(
                  //textAlign: TextAlign.center,
                  controller: _amountController,
                  style: Theme.of(context).textTheme.headline,
                  readOnly: _pageMode==PageMode.edit && _transaction.idTransactionParent!=null,
                  autofocus: _pageMode==PageMode.add,
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
                color: _transaction?.account?.color==null?Colors.grey:ColorsApp(context).getColorDataByKey(_transaction?.account?.color)['color'],),
                title: Text(_transaction?.account?.name??''),
                trailing: _transaction?.transactionType==TransactionType.Transfer?Icon(MdiIcons.bankTransferOut,color: Colors.red):null,
                onTap: _onTabAccount,
              ),
              Visibility(
                visible: _transaction?.transactionType==TransactionType.Transfer,
                child: ListTile(
                  leading: Icon(MdiIcons.walletOutline,
                    color: _transaction?.accountTransfer?.color==null?Colors.grey:ColorsApp(context).getColorDataByKey(_transaction?.accountTransfer?.color)['color'],),
                  title: Text(_transaction?.accountTransfer?.name??''),
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
                title: _transaction?.date ==null?Text(''):Text(DateFormat.yMMMMEEEEd().format(_transaction?.date)),
                onTap: _transaction.idTransactionParent==null?_onTabDate:null,
              ),
              Visibility(
                visible: _transaction.idTransactionParent==null,
                child: ListTile(
                  leading: Icon(Icons.repeat),
                  title: Text(_getTitleRepeat(_transaction?.repeatMode,repeatEveryCount: _transaction?.repeatEveryCount)),
                  subtitle: Text('Recurrencia'),
                  onTap: _onTabRepeat,
                ),
              ),
              Visibility(visible: _transaction.idTransactionParent==null,child: Divider()),
              Visibility(
                visible: _transaction.idTransactionParent==null,
                child: ListTile(
                  enabled: DateTime(_transaction.date.year,_transaction.date.month,_transaction.date.day)
                    .isAfter(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day)),
                  leading: Icon(Icons.notifications_none),
                  title: Text((){
                    switch (_transaction?.notifyTimeType) {
                      case NotifyTimeType.Minutes: return '${_transaction?.notifyTimes} minutos antes';
                      case NotifyTimeType.Hours: return '${_transaction?.notifyTimes} horas antes';
                      case NotifyTimeType.Days: return '${_transaction?.notifyTimes} dias antes';
                      case NotifyTimeType.Weeks: return '${_transaction?.notifyTimes} semanas antes';
                      default: return 'Sin notificación';
                    }
                  }()),
                  subtitle: Text('Notificacion'),
                  onTap: _onTabNotification,
                ),
              ),
              Visibility(
                visible: _transaction?.transactionType!=TransactionType.Transfer && _transaction.idTransactionParent==null,
                child: Divider()
              ),
              Visibility(
                visible: _transaction?.transactionType!=TransactionType.Transfer,
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
                  onTap:_transaction.idTransactionParent==null?_onTabLabels:null,
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
          );
        }
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
          if(account?.id==_transaction.accountTransfer?.id){
            _transaction.accountTransfer=null;
          }
          _transaction.account=account;
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
          if(account?.id==_transaction?.account?.id){
            _transaction.account=null;
          }
          _transaction.accountTransfer=account;
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
          if(!DateTime(date.year,date.month,date.day).isAfter(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day))){
            _transaction.notifyTimeType=NotifyTimeType.NotNotify;
          }
        });
      }
    });
  }

  _getTitleRepeat(TransactionRepeatMode repeatMode,{int repeatEveryCount}){
    switch (repeatMode) {
      case TransactionRepeatMode.NotRepeat: return 'No se repite';
      case TransactionRepeatMode.EveryDay: return 'Todos los dias';
      case TransactionRepeatMode.EveryWeek: return 'Todas las semanas';
      case TransactionRepeatMode.EveryMonth: return 'Todos los meses';
      case TransactionRepeatMode.EveryYear: return 'Todos los años';
      case TransactionRepeatMode.Custom:
        String label='Se repite ';
        if(_transaction.repeatEvery==TransactionRepeatEvery.Days)label+='cada ${_transaction.repeatEveryCount} dias';
        if(_transaction.repeatEvery==TransactionRepeatEvery.Weeks)label+='cada ${_transaction.repeatEveryCount} semanas';
        if(_transaction.repeatEvery==TransactionRepeatEvery.Months)label+='cada ${_transaction.repeatEveryCount} meses';
        if(_transaction.repeatEvery==TransactionRepeatEvery.Years)label+='cada ${_transaction.repeatEveryCount} años';
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
              'label':_getTitleRepeat(TransactionRepeatMode.Custom,repeatEveryCount: _transaction.repeatEveryCount)
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
                          builder: (BuildContext context) => CustomRepeatPage(
                            transaction: _transaction,
                          )
                        ))
                          .then((transaction){
                            if(value!=null){
                              setState(() {
                                _transaction=transaction;
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
          text: (_transaction.notifyTimes??10).toInt().toString()
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
                        'value':NotifyTimeType.NotNotify,
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
                          textEnabled=value!=NotifyTimeType.NotNotify;
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
      transactionType: _transaction.transactionType,
      initialLabelsSelected: _transaction.labels,
    )))
      .then((List<Label> labels){
        setState(() {
          _transaction.labels=labels;
        });
      });
  }

  _save()async{
    _transaction.amount=double.tryParse(_amountController.text.replaceAll(',', ''));
    _transaction.description=_descriptionController.text;
    _transaction.notes=_notesController.text;

    if(!isNumeric(_transaction.amount.toString()))return;
    if(_transaction.description.length==0){
      _transaction.description='Desde '+_transaction.account.name;
    }
    if(_transaction.accountTransfer==null && _transaction.transactionType==TransactionType.Transfer)return;
    if(_pageMode==PageMode.add){
      int id=await Transaction.add(_transaction);
      if(_transaction.repeatMode!=TransactionRepeatMode.NotRepeat && _transaction.finishRepeatMode==TransactionFinishMode.AfterRepeat){
        List<Transaction> transactionChildren=[];
        for (int i = 0; i < _transaction.finishAfterRepeat; i++) {
          transactionChildren.add(Transaction(
            idTransactionParent: id,
            amount: _transaction.amount,
            account: _transaction.account,
            accountTransfer: _transaction.accountTransfer,
            description: _transaction.description+' (${i+1}/${_transaction.finishAfterRepeat})',
            transactionType: _transaction.transactionType,
            date: _transaction.date,
            idUser: _transaction.idUser,
            labels: _transaction.labels,
          ));
        }

        await Future.wait(transactionChildren.map((t)=>Transaction.add(t)).toList());
      }
      
      _transactionBloc.add(LoadTransactionsRepeat());
      _transactionBloc.add(LoadTransactions(
        offset: 0,
        clearOldTransactions: true,
      ));

      Navigator.pop(context);
    }
    if(_pageMode==PageMode.edit){
      Transaction.editById(_transaction);

      Navigator.pop(context);
      _transactionBloc.add(LoadTransactionsRepeat());
      _transactionBloc.add(LoadTransactions(
        offset: 0,
        clearOldTransactions: true,
      ));
    }

  }

  _delete()async{
    bool confirmUser= await showDialog<bool>(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text('Esta seguro de borrar esta transacción?'),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancelar'),
              onPressed: ()=>Navigator.pop(context,false)
            ),
            FlatButton(
              textColor: Colors.red,
              child: Text('Borrar'),
              onPressed: ()=>Navigator.pop(context,true),
            )
          ],
        );
      }
    );
    
    if((confirmUser??false)){
      if(_transaction.repeatMode!=TransactionRepeatMode.NotRepeat && _transaction.finishRepeatMode==TransactionFinishMode.AfterRepeat){
        List<Transaction> transactionsDelete=await Transaction.select(idTransactionParent: _transaction.id,limit: 0);
        for (int i = 0; i < transactionsDelete.length; i++) {
          await Transaction.deleteById(transactionsDelete[i].id);
        }
        //await Future.wait(transactionsDelete.map((t)=>Transaction.deleteById(t.id)));
      }
      await Transaction.deleteById(_transaction.id);

      _transactionBloc.add(LoadTransactionsRepeat());
      _transactionBloc.add(LoadTransactions(
        offset: 0,
        clearOldTransactions: true,
      ));
      Navigator.pop(context);
    }

  }
}