import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:silverkeep/db/models/Transaction.dart';

class CustomNotificationPage extends StatefulWidget {
  
  final Transaction transaction; 

  const CustomNotificationPage({Key key,this.transaction}) : super(key: key);

  @override
  _CustomNotificationPageState createState() => _CustomNotificationPageState();
}

class _CustomNotificationPageState extends State<CustomNotificationPage> {

  FocusNode _focusNode;

  TextEditingController _textController;

  Transaction _transaction;
  DateTime _dateFinish;

  @override
  void initState() {
    super.initState();

    _focusNode=FocusNode();
    _focusNode.addListener((){
      if(_focusNode.hasFocus)
        _textController.selection=TextSelection(baseOffset: 0, extentOffset: _textController.text.length);
    });

    _transaction=widget.transaction;
    if(_transaction.repeatEvery==null)_transaction.repeatEvery=TransactionRepeatEvery.Days;
    if(_transaction.monday==null)_transaction.monday=false;
    if(_transaction.tuesday==null)_transaction.tuesday=false;
    if(_transaction.saturday==null)_transaction.saturday=false;
    if(_transaction.thursday==null)_transaction.thursday=false;
    if(_transaction.wednesday==null)_transaction.wednesday=false;
    if(_transaction.sunday==null)_transaction.sunday=false;
    if(_transaction.friday==null)_transaction.friday=false;

    if(_transaction.dateFinish!=null)_dateFinish=_transaction.dateFinish;
    else _dateFinish=DateTime.now().add(Duration(days: 30));

    _textController=TextEditingController(text: _transaction.repeatCount.toString());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.close), onPressed: ()=>Navigator.pop(context)),
        title:Text('Repeticiones personalizada'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _onSubmit,
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          _buildLabel('Se repite cada dia'),
          ListTile(
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 48,
                  child: TextField(
                    controller: _textController,
                    focusNode: _focusNode,
                    keyboardType: TextInputType.numberWithOptions(signed: false,decimal: false),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration.collapsed(
                      hintText: '',
                      border: OutlineInputBorder(),
                      fillColor: Colors.grey.shade200,
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(2),
                      WhitelistingTextInputFormatter.digitsOnly,
                      TextInputFormatter.withFunction((TextEditingValue oldValue, TextEditingValue newValue){
                        if(newValue.text.length==0)return newValue;
                        if(newValue.text[0]=='0')return newValue.copyWith(text: '1');
                        return newValue;
                      })
                    ],
                    onChanged: (String text)=>setState(()=>_transaction.repeatCount=int.parse(text)),
                  ),
                ),
                SizedBox(width: 13,),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    height: 48,
                    child: Material(
                      color: Colors.grey.shade200,
                      child: PopupMenuButton(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(width: 6,),
                            Text((){
                              switch (_transaction.repeatEvery) {
                                case TransactionRepeatEvery.Days:return 'Dias';
                                case TransactionRepeatEvery.Weeks:return 'Semanas';
                                case TransactionRepeatEvery.Months:return 'Meses';
                                case TransactionRepeatEvery.Years:return 'Años';
                                default: return '';
                              }
                            }()),
                            Icon(Icons.arrow_drop_down),
                          ],
                        ),
                        itemBuilder: (BuildContext context){
                          return <PopupMenuItem<TransactionRepeatEvery>>[
                            new PopupMenuItem<TransactionRepeatEvery>(
                              child: const Text('Dias'), value: TransactionRepeatEvery.Days
                            ),
                            new PopupMenuItem<TransactionRepeatEvery>(
                              child: const Text('Semanas'), value: TransactionRepeatEvery.Weeks
                            ),
                            new PopupMenuItem<TransactionRepeatEvery>(
                              child: const Text('Meses'), value: TransactionRepeatEvery.Months
                            ),
                            new PopupMenuItem<TransactionRepeatEvery>(
                              child: const Text('Años'), value: TransactionRepeatEvery.Years
                            ),
                          ];                    
                        },
                        onSelected: (TransactionRepeatEvery value)=>setState(()=>_transaction.repeatEvery=value),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Visibility(
            visible: _transaction.repeatEvery==TransactionRepeatEvery.Weeks,
            child: _buildWeekRepeat(),
          ),
          Divider(),
          _buildLabel('Finaliza'),
          RadioListTile<DateTime>(
            value: null,
            groupValue: _transaction.dateFinish,
            title: Text('Nunca'),
            onChanged: _onChangeDateFinish
          ),
          RadioListTile<DateTime>(
            value: _dateFinish,
            groupValue: _transaction.dateFinish,
            title: GestureDetector(
              child: Row(
                children: <Widget>[
                  Text('El ${DateFormat.yMMMMEEEEd().format(_dateFinish)}'),
                ],
              ),
              onTap: _onTabDateFinish,
            ),
            secondary: IconButton(
              icon: Icon(Icons.date_range),
              onPressed: _onTabDateFinish
            ),
            onChanged: _onChangeDateFinish
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text){
    return ListTile(
      title:Text(text.toUpperCase(),style: Theme.of(context).textTheme.subtitle,),
    );
  }

  Widget _buildWeekRepeat(){
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Divider(),
          _buildLabel('Se repite el'),
          ListTile(
            title: Wrap(
              spacing: 7,
              runSpacing: 7,
              children: <Widget>[
                _buildCircleCheck(text: 'L',selected: _transaction.monday,onTab: ()=>setState(()=>_transaction.monday=!_transaction.monday)),
                _buildCircleCheck(text: 'M',selected: _transaction.tuesday,onTab: ()=>setState(()=>_transaction.tuesday=!_transaction.tuesday)),
                _buildCircleCheck(text: 'M',selected: _transaction.wednesday,onTab: ()=>setState(()=>_transaction.wednesday=!_transaction.wednesday)),
                _buildCircleCheck(text: 'J',selected: _transaction.thursday,onTab: ()=>setState(()=>_transaction.thursday=!_transaction.thursday)),
                _buildCircleCheck(text: 'V',selected: _transaction.friday,onTab: ()=>setState(()=>_transaction.friday=!_transaction.friday)),
                _buildCircleCheck(text: 'S',selected: _transaction.saturday,onTab: ()=>setState(()=>_transaction.saturday=!_transaction.saturday)),
                _buildCircleCheck(text: 'D',selected: _transaction.sunday,onTab: ()=>setState(()=>_transaction.sunday=!_transaction.sunday)),
              ],
            ),
          )
        ],
      ),
    );
  }

  // Widget _buildMonthRepeat(){
  //   return Container(
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: <Widget>[
  //         Divider(),
  //         _buildLabel(text: '')
  //         Divider()
  //       ],
  //     ),
  //   );
  //}

  Widget _buildContainer({Widget child,double width}){
    return Container(
      height: 48,
      width: width,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.grey.shade200,
      ),
      child: LimitedBox(
        maxWidth: 100,
        child: Center(
          child: child
        )
      ),
    );
  }

  Widget _buildCircleCheck({String text='',bool selected=false,Function onTab})
  {
    return GestureDetector(
      onTap: onTab,
      child: Container(
        height: 35,
        width: 35,
        child: CircleAvatar(
          backgroundColor: selected?Theme.of(context).primaryColor:Colors.grey.shade300,
          foregroundColor: selected?Colors.white:Colors.black,
          child: Text(text),
        ),
      ),
    );
  }

  void _onChangeDateFinish(DateTime date){
    setState((){
      if(date!=null)_dateFinish=date;
      _transaction.dateFinish=date;
    });
  }

  void _onTabDateFinish (){
    showDatePicker(
      context: context,
      initialDate: _transaction.dateFinish??DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(Duration(days: 36500))
    )
    .then((DateTime date){
      if(date!=null){
        setState(() {
          setState((){
            if(date!=null)_dateFinish=date;
            _transaction.dateFinish=date;
          });
        });
      }
    });
  }

  void _onSubmit(){
    if(_transaction.repeatCount.toString().length==0){
      _transaction.repeatCount=1;
    }
    _transaction.repeatMode=TransactionRepeatMode.Custom;
    Navigator.pop(context,_transaction);
  }
}